from django.shortcuts import redirect
from django.shortcuts import render
from django.utils import translation
from django.http import HttpRequest, HttpResponse
from django.http import JsonResponse
from django.views.generic.base import TemplateView, View
from django.views.generic.edit import BaseDeleteView, FormView
from django.utils.decorators import method_decorator
from django.db import transaction, connection
from django.contrib.auth.tokens import default_token_generator
from django.views.decorators.cache import never_cache
from django.views.decorators.debug import sensitive_post_parameters
from django.contrib.auth import REDIRECT_FIELD_NAME, login as auth_login, logout as auth_logout
from django import forms as baseforms
from datetime import datetime, timedelta

import pandas as pd
import numpy as np
import json
from .tradlablib import chartpattern as cp
from .tradlablib import pricebarpattern as pp
from .tradlablib import technicalindicator as tind
from .tradlablib import pricedata as prd
from .tradlablib.indicatorparameter import *
from .tradlablib.plotsetting import *
from .tradlablib.backtest import *
from .tradlablib import tradelib
from . import forms, models, tasks
import structlog
import configparser
from episectrad import settings
from .tradlablib import backtest as bt

import requests
from datetime import datetime, timedelta
import time
from pandas_datareader import data
import pandas_datareader.data as web
from statsmodels.tsa.stattools import adfuller
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.stattools import acf, pacf
from statsmodels.tsa.arima_model import ARIMA

from sklearn.model_selection import train_test_split
from keras.models import Sequential
from keras.layers import Dense, Dropout, LSTM
# to plot within notebook
import matplotlib.pyplot as plt

MAX_TRADE_COUNT = 4

logger = structlog.get_logger()


# function to calculate percentage difference considering baseValue as 100%
def percentageChange(baseValue, currentValue):
    return ((float(currentValue) - baseValue) / abs(baseValue)) * 100.00


# function to get the actual value using baseValue and percentage
def reversePercentageChange(baseValue, percentage):
    return float(baseValue) + float(baseValue * percentage / 100.00)


# function to transform a list of values into the list of percentages. For calculating percentages for each element in the list
# the base is always the previous element in the list.
def transformToPercentageChange(x):
    baseValue = x[0]
    x[0] = 0
    for i in range(1, len(x)):
        pChange = percentageChange(baseValue, x[i])
        baseValue = x[i]
        x[i] = pChange


# function to transform a list of percentages to the list of actual values. For calculating actual values for each element in the list
# the base is always the previous calculated element in the list.
def reverseTransformToPercentageChange(baseValue, x):
    x_transform = []
    for i in range(0, len(x)):
        value = reversePercentageChange(baseValue, x[i])
        baseValue = value
        x_transform.append(value)
    return x_transform

def predict_stock(dataset, baseValue, new_data, option):

    train, valid = train_test_split(dataset, train_size=0.99, test_size=0.01, shuffle=False)

    # convert dataset into x_train and y_train.
    # prediction_window_size is the size of days windows which will be considered for predicting a future value.
    prediction_window_size = 6
    x_train, y_train = [], []
    for i in range(prediction_window_size, len(train)):
        x_train.append(dataset[i - prediction_window_size:i, 0])
        y_train.append(dataset[i, 0])
    x_train, y_train = np.array(x_train), np.array(y_train)
    x_train = np.reshape(x_train, (x_train.shape[0], x_train.shape[1], 1))

    ##################################################################################################
    # create and fit the LSTM network
    # Initialising the RNN
    model = Sequential()
    # Adding the first LSTM layer and some Dropout regularisation
    model.add(LSTM(units=5, return_sequences=True, input_shape=(x_train.shape[1], 1)))
    model.add(Dropout(0.2))

    # Adding a second LSTM layer and some Dropout regularisation
    model.add(LSTM(units=5, return_sequences=True))
    model.add(Dropout(0.2))

    # Adding a third LSTM layer and some Dropout regularisation
    model.add(LSTM(units=50, return_sequences=True))
    model.add(Dropout(0.2))

    # Adding a fourth LSTM layer and some Dropout regularisation
    model.add(LSTM(units=5))
    model.add(Dropout(0.2))

    # Adding the output layer
    model.add(Dense(units=1))
    # Compiling the RNN
    model.compile(optimizer='adam', loss='mean_squared_error')

    # Fitting the RNN to the Training set
    model.fit(x_train, y_train, epochs=50, batch_size=8)

    ##################################################################################################

    # predicting future values, using past 60 from the train data
    # for next 10 yrs total_prediction_days is set to 3650 days
    total_prediction_days = 150
    inputs = new_data[-total_prediction_days:].values
    inputs = inputs.reshape(-1, 1)

    # create future predict list which is a two dimensional list of values.
    # the first dimension is the total number of future days
    # the second dimension is the list of values of prediction_window_size size
    X_predict = []
    for i in range(prediction_window_size, inputs.shape[0]):
        X_predict.append(inputs[i - prediction_window_size:i, 0])
    X_predict = np.array(X_predict)

    # predict the future
    X_predict = np.reshape(X_predict, (X_predict.shape[0], X_predict.shape[1], 1))
    future_closing_price = model.predict(X_predict)

    train, valid = train_test_split(new_data, train_size=0.99, test_size=0.01, shuffle=False)
    date_index = pd.to_datetime(train.index)

    # converting dates into number of days as dates cannot be passed directly to any regression model
    x_days = (date_index - pd.to_datetime('2019-08-28')).days

    # we are doing prediction for next 5 years hence prediction_for_days is set to 1500 days.
    prediction_for_days = 100
    future_closing_price = future_closing_price[:prediction_for_days]

    # create a data index for future dates
    x_predict_future_dates = np.asarray(
        pd.RangeIndex(start=x_days[-1] + 1, stop=x_days[-1] + 1 + (len(future_closing_price))))
    future_date_index = pd.to_datetime(x_predict_future_dates, origin='2019-08-28', unit='D')

    # transform a list of relative percentages to the actual values
    train_transform = reverseTransformToPercentageChange(baseValue, train[option])

    # for future dates the base value the the value of last element from the training set.
    baseValue = train_transform[-1]
    valid_transform = reverseTransformToPercentageChange(baseValue, valid[option])
    future_closing_price_transform = reverseTransformToPercentageChange(baseValue, future_closing_price)

    return future_closing_price_transform


def switch_language(request, language):
    translation.activate(language)
    request.session[translation.LANGUAGE_SESSION_KEY] = language
    return redirect('/admin')


class LoginView(FormView):
    template_name = "dashboard/admin/login.html"
    form_class = forms.AuthenticationForm
    redirect_field_name = REDIRECT_FIELD_NAME
    success_url = "/"

    def form_valid(self, form):
        user = form.get_user()
        auth_login(self.request, user)
        logger.bind(email=user.email).info("User had logged in")
        return super().form_valid(form)


class LogoutView(View):
    def post(self, request):
        if request.user.is_authenticated:
            logger.bind(email=request.user.email).info("User had logged out")
        logout(request)
        return redirect("index")


class SignupView(FormView):
    template_name = "dashboard/admin/signup.html"
    form_class = forms.UserCreationForm
    success_url = "/signup/email-sent"

    # success_url = "/signup/email-sent"

    def form_valid(self, form):
        user = form.save(commit=False)
        user.email_confirmed = False
        user.save()
        logger.bind(email=user.email).info("User had signed up (email confirmation pending)")
        request_context = {
            "domain": self.request.META["HTTP_HOST"],
            "protocol": "https" if self.request.is_secure() else "http",
        }

        return super().form_valid(form)


class SignupEmailSentView(TemplateView):
    template_name = "dashboard/admin/signup_email_sent.html"


class SignupConfirmView(TemplateView):
    template_name = "dashboard/signup_bad_link.html"
    token_generator = default_token_generator
    success_url = "/dashboard/"

    @method_decorator(sensitive_post_parameters())
    @method_decorator(never_cache)
    @method_decorator(transaction.atomic)
    def dispatch(self, *args, **kwargs):
        assert "uidb64" in kwargs and "token" in kwargs

        user = self.get_user(kwargs["uidb64"])
        if user is not None and not user.email_confirmed:
            log = logger.bind(user=user, email=user.email)
            token = kwargs["token"]
            if self.token_generator.check_token(user, token):
                log.info("User had confirmed their email address")
                user.email_confirmed = True
                user.save(update_fields=["email_confirmed"])
                if not self.request.user.is_authenticated():
                    login(self.request, user)
                request_context = {
                    "domain": self.request.META["HTTP_HOST"],
                    "protocol": "https" if self.request.is_secure() else "http",
                }
                tasks.send_signup_confirmed_email.apply_async(kwargs={"user_pk": user.pk,
                                                                      "extra_email_context": request_context})
                return redirect(self.success_url)
            else:
                log.warn("User had visited invalid or expired link")
        elif user is not None:
            logger.bind(user=user, email=user.email).info("Email address is already confirmed")
        else:
            logger.warn("Bad signup link - user not found")

        # Display the "Invalid or expired link" page.
        return self.render_to_response(self.get_context_data(user=user))

    @staticmethod
    def get_user(uidb64):
        try:
            # urlsafe_base64_decode() decodes to bytestring on Python 3
            uid = force_text(urlsafe_base64_decode(uidb64))
            user = models.User.objects.select_for_update().get(pk=uid)
        except (TypeError, ValueError, OverflowError, models.User.DoesNotExist):
            user = None
        return user


symbol = 'AAPL'
period = '36m'
interval = '5min'
bIntraday = 0
df = pd.DataFrame()

pricebarpatternalert = dict()


class tradlab:

    def dashtradlab(request, dashboard_id=0):
        assert isinstance(request, HttpRequest)
        if request.method == 'GET' and 'riskshow' in request.GET:
            riskshow = request.GET.get('riskshow')
        else:
            riskshow = 'no';

        if dashboard_id == 0:
            dashboard = models.Dashboard.objects.all().first()
        else:
            dashboard = models.Dashboard.objects.get(id=dashboard_id)

        if dashboard is None:

            dashboard = models.Dashboard()
            dashboard.save()

            df = prd.importLiveData(dashboard)

            if df is None:
                return HttpResponse('Data Importing Failed!')
        else:
            df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC' + str(dashboard.id) + '.csv', sep=',')

            # start = pd.Timestamp('2019-1-1')
            # end = pd.Timestamp(datetime.today())
            #
            # f = web.DataReader('F', 'yahoo', start, end)
            # print(f)

            df = pd.DataFrame(df)

        symbol = dashboard.symbol
        period = dashboard.period
        interval = dashboard.interval
        bIntraday = dashboard.bIntraday

        dashboards = models.Dashboard.objects.all()
        # pricebarpatternalert = pp.patternanal(df)

        # trade ready

        # TradeSettingIndicator.objects.get(user=request.user)
        tradeis = models.TradeIndicator.objects.filter(backtest__dashboard__id=dashboard.id)

        trades = tradelib.get_trades_plotresult(df, tradeis)
        # print(trades)
        # options ready
        # print(cp.bullishpatternnames)
        chartpatterns = []
        for i in range(len(cp.bullishpatternnames)):
            chartpatterns.append({'bullish': cp.bullishpatternnames[i], 'bearish': cp.bearishpatternnames[i]})

        barpatterns = []
        for i in range(len(pp.PriceBarBullishPatterns)):
            barpatterns.append({'bullish': pp.PriceBarBullishPatterns[i], 'bearish': pp.PriceBarBearishPatterns[i]})

        now = datetime.now()
        nowdatestr = now.strftime("%d/%m/%y")

        backtest_choices = []

        for m in prd.HISTORICAL_TIMESERIES_PERIODS:
            days = prd.PREIOD_DAYS.get(m)
            past = now - timedelta(days=days)
            pastdatestr = past.strftime("%d/%m/%y")
            backtest_choices.append({'period': m, 'start': pastdatestr, 'end': nowdatestr})

        all_indicators = {}
        with connection.cursor() as cursor:
            cursor.execute("select category from indicators group by category")
            rows = cursor.fetchall()
            # print(rows)
            for row in rows:
                indids = []
                for i in models.Indicator.objects.filter(category=row[0]):
                    indids.append([i.name, i.id_letter, i.possible_combine])
                all_indicators[row[0]] = indids

        plot_settings = get_tis_plot_settings(tradeis)
        # print(plot_settings)
        return render(
            request,
            'dashboard/dashboard/tradelaboratory.html',
            context={
                'ChartPatterns': chartpatterns,
                'BarPatterns': barpatterns,
                'Prices': df.to_json(orient='records'),
                'Indicators': all_indicators,
                'Intervals': prd.INTRADAY_TIMESERIES_INTERVAL,
                'Periods': backtest_choices,
                'Interval': interval,
                'Period': period,
                'bIntraday': bIntraday,
                'Symbol': symbol,
                'Backtests': dashboard.backtest_set.all(),
                'TradingIndicatorResults': trades,
                'PlotSettings': plot_settings,
                'EnterSignal': dashboard.enter_signal,
                'Dashboard_ID': dashboard.id,
                'Dashboards': dashboards,
            }
        )

    def risktoreward(request):
        assert isinstance(request, HttpRequest)
        if request.method == 'GET' and 'riskshow' in request.GET:
            riskshow = request.GET.get('riskshow')
        else:
            riskshow = 'no';

        dashboard_id = request.GET.get('dashboard_id', 0)
        dashboard = models.Dashboard.objects.get(id=dashboard_id)
        #
        # df = prd.importLiveData(dashboard)

        df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC1.csv', sep=',')
        df = pd.DataFrame(df)

        # if df is None:
        #     return JsonResponse(status=404, data={'status': 'false', 'message': 'Invalid symbol name'})

        dashboard.save()

        prices = df

        # print('ok', prices)

        baseValue = df['Close'][0]
        baseValue1 = df['Open'][0]
        baseValue2 = df['High'][0]
        baseValue3 = df['Low'][0]
        baseValue4 = df['Volume'][0]

        # create a new dataframe which is then transformed into relative percentages

        data = df.sort_index(ascending=True, axis=0)
        # print(data)
        new_data = pd.DataFrame(index=range(0, len(df)), columns=['Date', 'Close'])
        new_data1 = pd.DataFrame(index=range(0, len(df)), columns=['Date', 'Open'])
        new_data2 = pd.DataFrame(index=range(0, len(df)), columns=['Date', 'High'])
        new_data3 = pd.DataFrame(index=range(0, len(df)), columns=['Date', 'Low'])
        new_data4 = pd.DataFrame(index=range(0, len(df)), columns=['Date', 'Volume'])

        for i in range(0, len(data)):
            new_data['Date'][i] = data['Date'][i]
            new_data['Close'][i] = data['Close'][i]
            new_data1['Date'][i] = data['Date'][i]
            new_data1['Open'][i] = data['Open'][i]
            new_data2['Date'][i] = data['Date'][i]
            new_data2['High'][i] = data['High'][i]
            new_data3['Date'][i] = data['Date'][i]
            new_data3['Low'][i] = data['Low'][i]
            new_data4['Date'][i] = data['Date'][i]
            new_data4['Volume'][i] = data['Volume'][i]

        # transform the 'Close' series into relative percentages
        transformToPercentageChange(new_data['Close'])
        transformToPercentageChange(new_data1['Open'])
        transformToPercentageChange(new_data2['High'])
        transformToPercentageChange(new_data3['Low'])
        transformToPercentageChange(new_data4['Volume'])

        # set Dat column as the index
        new_data.index = new_data.Date
        new_data1.index = new_data.Date
        new_data2.index = new_data.Date
        new_data3.index = new_data.Date
        new_data4.index = new_data.Date
        new_data.drop('Date', axis=1, inplace=True)
        new_data1.drop('Date', axis=1, inplace=True)
        new_data2.drop('Date', axis=1, inplace=True)
        new_data3.drop('Date', axis=1, inplace=True)
        new_data4.drop('Date', axis=1, inplace=True)

        # create train and test sets
        dataset = new_data.values
        dataset1 = new_data1.values
        dataset2 = new_data2.values
        dataset3 = new_data3.values
        dataset4 = new_data4.values

        future_closing_price_transform1 = predict_stock(dataset1, baseValue1, new_data1, 'Open')
        future_closing_price_transform2 = predict_stock(dataset2, baseValue2, new_data2, 'High')
        future_closing_price_transform3 = predict_stock(dataset3, baseValue3, new_data3, 'Low')
        future_closing_price_transform4 = predict_stock(dataset4, baseValue4, new_data4, 'Volume')

        train, valid = train_test_split(dataset, train_size=0.99, test_size=0.01, shuffle=False)

        # convert dataset into x_train and y_train.
        # prediction_window_size is the size of days windows which will be considered for predicting a future value.
        prediction_window_size = 6
        x_train, y_train = [], []
        for i in range(prediction_window_size, len(train)):
            x_train.append(dataset[i - prediction_window_size:i, 0])
            y_train.append(dataset[i, 0])
        x_train, y_train = np.array(x_train), np.array(y_train)
        x_train = np.reshape(x_train, (x_train.shape[0], x_train.shape[1], 1))

        ##################################################################################################
        # create and fit the LSTM network
        # Initialising the RNN
        model = Sequential()
        # Adding the first LSTM layer and some Dropout regularisation
        model.add(LSTM(units=5, return_sequences=True, input_shape=(x_train.shape[1], 1)))
        model.add(Dropout(0.2))

        # Adding a second LSTM layer and some Dropout regularisation
        model.add(LSTM(units=5, return_sequences=True))
        model.add(Dropout(0.2))

        # Adding a third LSTM layer and some Dropout regularisation
        model.add(LSTM(units=5, return_sequences=True))
        model.add(Dropout(0.2))

        # Adding a fourth LSTM layer and some Dropout regularisation
        model.add(LSTM(units=5))
        model.add(Dropout(0.2))

        # Adding the output layer
        model.add(Dense(units=1))
        # Compiling the RNN
        model.compile(optimizer='adam', loss='mean_squared_error')

        # Fitting the RNN to the Training set
        model.fit(x_train, y_train, epochs=50, batch_size=8)

        ##################################################################################################

        # predicting future values, using past 60 from the train data
        # for next 10 yrs total_prediction_days is set to 3650 days
        total_prediction_days = 150
        inputs = new_data[-total_prediction_days:].values
        inputs = inputs.reshape(-1, 1)

        # create future predict list which is a two dimensional list of values.
        # the first dimension is the total number of future days
        # the second dimension is the list of values of prediction_window_size size
        X_predict = []
        for i in range(prediction_window_size, inputs.shape[0]):
            X_predict.append(inputs[i - prediction_window_size:i, 0])
        X_predict = np.array(X_predict)

        # predict the future
        X_predict = np.reshape(X_predict, (X_predict.shape[0], X_predict.shape[1], 1))
        future_closing_price = model.predict(X_predict)

        train, valid = train_test_split(new_data, train_size=0.99, test_size=0.01, shuffle=False)
        date_index = pd.to_datetime(train.index)

        # converting dates into number of days as dates cannot be passed directly to any regression model
        x_days = (date_index - pd.to_datetime('2019-08-28')).days

        # we are doing prediction for next 5 years hence prediction_for_days is set to 1500 days.
        prediction_for_days = 100
        future_closing_price = future_closing_price[:prediction_for_days]

        # create a data index for future dates
        x_predict_future_dates = np.asarray(
            pd.RangeIndex(start=x_days[-1] + 1, stop=x_days[-1] + 1 + (len(future_closing_price))))
        future_date_index = pd.to_datetime(x_predict_future_dates, origin='2019-08-28', unit='D')

        # transform a list of relative percentages to the actual values
        train_transform = reverseTransformToPercentageChange(baseValue, train['Close'])

        # for future dates the base value the the value of last element from the training set.
        baseValue = train_transform[-1]
        valid_transform = reverseTransformToPercentageChange(baseValue, valid['Close'])
        future_closing_price_transform = reverseTransformToPercentageChange(baseValue, future_closing_price)

        # recession peak date is the date on which the index is at the bottom most position.
        recessionPeakDate = future_date_index[future_closing_price_transform.index(min(future_closing_price_transform))]
        minCloseInFuture = min(future_closing_price_transform);
        print("The stock market will reach to its lowest bottom on", recessionPeakDate)
        print("The lowest index the stock market will fall to is ", minCloseInFuture)


        # appending

        df_close = df['Close']
        df_date = df['Date']
        df_high = df['High']
        df_low = df['Low']
        df_open = df['Open']
        df_volume = df['Volume']

        future_closing_price_transform = pd.DataFrame(future_closing_price_transform)
        future_closing_price_transform1 = pd.DataFrame(future_closing_price_transform1)
        future_closing_price_transform2 = pd.DataFrame(future_closing_price_transform2)
        future_closing_price_transform3 = pd.DataFrame(future_closing_price_transform3)
        future_closing_price_transform4 = pd.DataFrame(future_closing_price_transform4)

        print(future_date_index.strftime('%Y-%m-%d %H:%M:%S'))
        future_date_index = pd.DataFrame(future_date_index.strftime('%Y-%m-%d %H:%M:%S'))

        df_close = df_close.append(future_closing_price_transform, ignore_index=True)
        df_open = df_open.append(future_closing_price_transform1, ignore_index=True)
        df_high = df_high.append(future_closing_price_transform2, ignore_index=True)
        df_low = df_low.append(future_closing_price_transform3, ignore_index=True)
        df_volume = df_volume.append(future_closing_price_transform4, ignore_index=True)
        df_date = df_date.append(future_date_index, ignore_index=True)

        df_mix = pd.concat([df_date, df_open, df_high, df_low,  df_close, df_volume], axis=1)
        df_mix.columns = ['Date', 'Open', 'High', 'Low', 'Close', 'Volume']

        print(df.Date[10])
        print(df_mix.Date[210])

        df = pd.DataFrame(df_mix)
        prices = pd.DataFrame(df_mix)

        print(df)
        # prices = prices.sort_values(by=['Date'])

        pastdatetimestr = prices['Date'][0]
        newprices = pd.DataFrame(columns=['Date', 'Open', 'High', 'Low', 'Close', 'Volume'])
        ninterval = interval.find('min')
        ninterval = int(interval[:ninterval])

        seconds = 60 * ninterval

        i = 0
        for index, row in prices.iterrows():
            pastdate = datetime.strptime(pastdatetimestr, '%Y-%m-%d %H:%M:%S').date()
            curdate = datetime.strptime(row['Date'], '%Y-%m-%d %H:%M:%S').date()
            if curdate != pastdate:
                newprices.loc[i] = row
                i = i + 1
                pastdatetimestr = row['Date']
            else:
                pasttime = datetime.strptime(pastdatetimestr, '%Y-%m-%d %H:%M:%S')
                curtime = datetime.strptime(row['Date'], '%Y-%m-%d %H:%M:%S')
                if curtime - pasttime == timedelta(seconds=seconds):
                    newprices.loc[i] = row
                    i = i + 1
                    pastdatetimestr = row['Date']

        prices = newprices
        # print(prices)
        newprices = prices['Close'].shift(1)
        # print(newprices)
        rets = prices['Close'] / newprices - 1
        # print(rets)
        profit = 0
        loss = 0
        profit_num = 0
        loss_num = 0
        for ret in rets:
            if (ret > 0):
                profit += ret
                profit_num += 1
            elif (ret < 0):
                # print(ret)
                loss += abs(ret)
                loss_num += 1
            # print(loss)
        avg_profit = profit / profit_num
        avg_loss = loss / loss_num
        ratio = avg_loss / avg_profit
        winrate = 1 / (1 + avg_profit / avg_loss)
        print("risk/reward ratio: ", ratio)
        # print(prices['Date'])

        entry = prices.iloc[-1, -2]
        # print(entry)

        tradeis = models.TradeIndicator.objects.filter(backtest__dashboard__id=dashboard.id)
        trades = tradelib.get_trades_plotresult(df, tradeis)

        print(trades)

        plot_settings = get_tis_plot_settings(tradeis)

        return JsonResponse(
            {'prices': df.to_json(orient='records'), 'trades': trades, 'ratio': ratio, 'settings': plot_settings,
             'entry': entry},
            safe=True)

    def recogpricebarpattern(request):
        assert isinstance(request, HttpRequest)

        patternname = request.GET.get('patternname', 'BULLISH HAMMER')
        dashboard_id = request.GET.get('dashboard_id', 0)

        df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC' + str(dashboard_id) + '.csv', sep=',')
        df = pd.DataFrame(df)
        data = pp.patternrecog(df, patternname)
        highs = list(np.array(df.High)[data['indexes']])
        lows = list(np.array(df.Low)[data['indexes']])
        result = {'dates': data['dates'], 'indexes': str(data['indexes']), 'lows': lows, 'highs': highs}

        response = JsonResponse(result, safe=True)
        return response

    def addpricebarpattern(request):
        assert isinstance(request, HttpRequest)

        patternname = request.GET.get('patternname', 'BULLISH HAMMER')
        dashboard_id = request.GET.get('dashboard_id', 0)

        backtest = models.Backtest()
        backtest.dashboard = models.Dashboard.objects.get(id=dashboard_id)
        backtest.mode = 1
        backtest.pricebar_pattern = patternname
        backtest.save()

        return HttpResponse("success")

    def recogchartpattern(request):
        assert isinstance(request, HttpRequest)

        patternname = request.GET.get('patternname', 'Ascending Triangle')
        dashboard_id = request.GET.get('dashboard_id', 0)
        df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC' + str(dashboard_id) + '.csv', sep=',')
        df = pd.DataFrame(df)
        result = cp.recogchartpattern(df, patternname)
        response = JsonResponse(result, safe=True)
        return response

    def addchartpattern(request):
        assert isinstance(request, HttpRequest)

        patternname = request.GET.get('patternname', 'Ascending Triangle')
        dashboard_id = request.GET.get('dashboard_id', 0)
        backtest = models.Backtest()
        backtest.dashboard = models.Dashboard.objects.get(id=dashboard_id)
        backtest.mode = 2
        backtest.chart_pattern = patternname
        backtest.save()
        return HttpResponse("success")

    def symbolperiodchange(request):
        assert isinstance(request, HttpRequest)

        dashboard_id = request.GET.get('dashboard_id', 0)

        newsymbol = request.GET.get('symbol', '')
        if newsymbol != '':
            symbol = newsymbol

        indicators = request.GET.getlist('indicators[]')

        bIntraday = int(request.GET.get('bIntraday', 0))
        newperiod = request.GET.get('period', '')
        newinterval = request.GET.get('interval', '')

        if newperiod != '':
            period = newperiod

        if newinterval != '':
            interval = newinterval

        # save setting start
        # if request.user.is_authenticated:
        #     dashboard = models.Dashboard.objects.get(user=request.user)

        dashboard = models.Dashboard.objects.get(id=dashboard_id)
        dashboard.bIntraday = bIntraday
        dashboard.period = period
        dashboard.interval = interval
        dashboard.symbol = symbol
        # save setting end

        df = prd.importLiveData(dashboard)

        if df is None:
            return JsonResponse(status=404, data={'status': 'false', 'message': 'Invalid symbol name'})

        dashboard.save()

        # trade ready

        # TradeSettingIndicator.objects.get(user=request.user)
        tradeis = models.TradeIndicator.objects.filter(backtest__dashboard__id=dashboard.id)
        trades = tradelib.get_trades_plotresult(df, tradeis)

        plot_settings = get_tis_plot_settings(tradeis)

        return JsonResponse({'prices': df.to_json(orient='records'), 'trades': trades, 'settings': plot_settings},
                            safe=True)

    def IndicatorSetting(request):
        assert isinstance(request, HttpRequest)

        if request.method == 'POST':
            # if not request.user.is_authenticated:
            #     return HttpResponse("user is not authenticated")
            tii_id = request.POST.get('tii_id', 0)
            dashboard_id = request.POST.get('dashboard_id', 0)
            # get model by ind id
            tii = models.TradeIndicatorIndicator.objects.get(id=tii_id)
            plots = tii.indicator.chartplot_set.all()

            settingvals = []
            for cp in plots:
                if cp.setting_manual:
                    color = request.POST.get('color_' + str(cp.id))
                    cpsetting = models.ChartPlotSetting.objects.update_setting(plot=cp, color=color)
                    # cpsetting = models.ChartPlotSetting.objects.update_setting(user=request.user, plot=cp, color=color)

                    # setting = models.ChartPlotSetting.objects.filter(plot=cp).first()

                    # if setting is None:
                    #     setting = models.ChartPlotSetting(plot=cp)
                    # setting.color = color
                    # setting.save()

                    settingvals.append({'plot_id': cp.id, 'plotname': cp.plotname, 'color': color, 'width': 1,
                                        'indicator_id': tii.indicator.id})

            iis = tii.indicator.indicatorinputs.all()

            for ii in iis:
                value = request.POST.get('input_' + ii.parameter)
                set_input_value(tii, ii.parameter, value)

            df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC' + str(dashboard_id) + '.csv', sep=',')
            df = pd.DataFrame(df)
            ti = tii.trade_indicator
            graphs = tradelib.get_trade_plotresult(df, ti)

            return JsonResponse({'tradeid': ti.id, 'trade': graphs, 'settings': settingvals, 'with_main': ti.with_main},
                                safe=True)

        else:

            tii_id = request.GET.get('tii_id', 0)
            dashboard_id = request.GET.get('dashboard_id', 0)

            # get model by ind id
            tii = models.TradeIndicatorIndicator.objects.get(id=tii_id)

            #  chart plot setting must be filtered by also user
            plot_settings = get_tii_plot_settings(tii)

            # get input value models
            inputs = []
            iis = tii.indicator.indicatorinputs.all()

            config = configparser.ConfigParser()
            ini = config.read('dashboard/tradlablib/params.ini')

            for ii in iis:
                value = get_input_value(tii, ii.parameter)
                defvalue = get_input_default_value(tii.indicator.param_name, ii.parameter)

                # source candidates
                cand = []

                if ii.parameter == 'close_col':
                    cand = ['Open', 'High', 'Low', 'Close']
                    for atii in tii.trade_indicator.tradeindicatorindicator_set.all():
                        if atii.id != tii.id:
                            for acp in atii.indicator.chartplot_set.all():
                                cand.append(acp.plotname)

                inputs.append({'parameter': ii.parameter, 'value': value, 'defvalue': defvalue, 'cand': cand})

        return render(
            request,
            'dashboard/dashboard/indicatorsetting.html',
            context={
                'dashboard_id': dashboard_id,
                'tii_id': tii_id,
                'PlotSettings': plot_settings,
                'Inputs': inputs,
            }
        )

    def SearchSymbols(request):
        assert isinstance(request, HttpRequest)

        keyword = request.GET.get('keyword', '')

        candidates = prd.symbolSearch(keyword)

        return JsonResponse(candidates, safe=False)

    def AddTradingIndicator(request):
        assert isinstance(request, HttpRequest)

        # if not request.user.is_authenticated:
        #     return HttpResponse("user is not authenticated")

        indid = request.GET.get('indid', '')
        dashboard_id = request.GET.get('dashboard_id', '')
        indicator = models.Indicator.objects.get(id_letter=indid)

        tis = models.TradeIndicator.objects.filter(backtest__dashboard__id=dashboard_id)
        wmtis = models.TradeIndicator.objects.filter(backtest__dashboard__id=dashboard_id, with_main=1)
        if len(tis) - len(wmtis) + 1 == MAX_TRADE_COUNT:
            return HttpResponse("countlimit")

        if indicator.combine_main:
            # ntrade = models.TradeIndicator.objects.get(user=request.user, with_main=True)
            ntrade = models.TradeIndicator.objects.filter(backtest__dashboard_id=dashboard_id,
                                                          with_main=1).first()  # if exist, its not new trade
            if ntrade is None:
                # ntrade = models.TradeIndicator(user=request.user, trade_mode=0)
                ntrade = models.TradeIndicator(backtest_mode=0, with_main=1)
                if indicator.value_indicator == 1:
                    ntrade.backtest_mode = 1
                ntrade.save()
                backtest = models.Backtest()
                backtest.dashboard = models.Dashboard.objects.get(id=dashboard_id)
                backtest.mode = 0
                backtest.tradeindicator = ntrade
                backtest.save()
        else:
            # ntrade = models.TradeIndicator(user=request.user, trade_mode=0)
            ntrade = models.TradeIndicator(backtest_mode=0)
            if indicator.value_indicator == 1:
                ntrade.backtest_mode = 1
            ntrade.save()
            backtest = models.Backtest()
            backtest.dashboard = models.Dashboard.objects.get(id=dashboard_id)
            backtest.mode = 0
            backtest.tradeindicator = ntrade
            backtest.save()

        ntii = ntrade.tradeindicatorindicator_set.create(indicator=indicator)

        df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC' + str(dashboard_id) + '.csv', sep=',')
        df = pd.DataFrame(df)
        graph = tradelib.get_trade_firstindicator_plotresult(df, ntii)

        return JsonResponse({'trade_id': ntrade.pk, 'graph': graph, 'with_main': indicator.combine_main}, safe=False)

    def AddTradingIndicatorIndicator(request):
        assert isinstance(request, HttpRequest)

        # if not request.user.is_authenticated:
        #     return HttpResponse("user is not authenticated")

        indid = request.GET.get('indid', '')
        trade_indicator_id = int(request.GET.get('trade_indicator_id', 0))
        dashboard_id = int(request.GET.get('dashboard_id', 0))
        if trade_indicator_id == 0:
            return HttpResponse("Trading Indicator ID is required!")
            # return tradlab.AddTradingIndicator(request)

        indicator = models.Indicator.objects.get(id_letter=indid)

        ntrade = models.TradeIndicator.objects.get(pk=trade_indicator_id)

        etii = ntrade.tradeindicatorindicator_set.filter(indicator=indicator)
        if etii.exists():
            return HttpResponse("Same Indicator already exists!")

        if ntrade.tradeindicatorindicator_set.all().count() == 2:
            return HttpResponse("Indicator combination count limit!")

        ntii = ntrade.tradeindicatorindicator_set.create(indicator=indicator)

        df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC' + str(dashboard_id) + '.csv', sep=',')
        df = pd.DataFrame(df)
        graph = tradelib.get_trade_indicator_plotresult(df, ntrade, ntii)

        return JsonResponse({'trade_id': ntrade.pk, 'graph': graph}, safe=False)

    def RemoveTradingIndicatorIndicator(request):
        assert isinstance(request, HttpRequest)

        # if not request.user.is_authenticated:
        #     return HttpResponse("user is not authenticated")

        indid = request.GET.get('indid', '')
        trade_indicator_id = request.GET.get('trade_indicator_id', 0)

        indicator = models.Indicator.objects.get(id_letter=indid)

        trade = models.TradeIndicator.objects.get(pk=trade_indicator_id)
        trade_indicator = models.TradeIndicatorIndicator.objects.get(trade_indicator=trade, indicator=indicator)
        trade_indicator.delete()

        if trade.tradeindicatorindicator_set.all().count() == 0:
            trade.delete()

        return HttpResponse("success")

    def RemoveTradingIndicator(request):
        assert isinstance(request, HttpRequest)

        # if not request.user.is_authenticated:
        #     return HttpResponse("user is not authenticated")

        trade_indicator_id = request.GET.get('trade_indicator_id', 0)
        trade = models.TradeIndicator.objects.get(pk=trade_indicator_id)
        trade.delete()

        return HttpResponse("success")

    def RemoveBacktest(request):
        assert isinstance(request, HttpRequest)

        backtest_id = request.GET.get('backtest_id', 0)
        backtest = models.Backtest.objects.get(pk=backtest_id)
        backtest.delete()

        return HttpResponse("success")

    def RefreshBacktestListPanel(request):
        assert isinstance(request, HttpRequest)

        dashboard_id = request.GET.get('dashboard_id', 0)
        backtests = models.Backtest.objects.filter(dashboard__id=dashboard_id).all()
        return render(
            request,
            'dashboard/dashboard/backtestlist.html',
            context={
                'Backtests': backtests,
            }
        )

    def TradingIndicatorOptionSave(request):
        assert isinstance(request, HttpRequest)

        jsonstr = request.GET.get('data')
        data = json.loads(jsonstr)
        # data = json.loads(list(request.GET.keys())[0])

        # trade = models.TradeIndicator.objects.get(id=data['trade_indicator_id'])
        # trade.signal = data['signal']
        # trade.attribute = data['attribute']
        # trade.save()
        tiid = data['trade_indicator_id']
        backtest_mode = data['backtest_mode']

        ti = models.TradeIndicator.objects.get(id=tiid)
        ti.backtest_mode = backtest_mode
        ti.save()

        tradelib.save_trade_indicator_options(data['options'])

        return HttpResponse("successfully saved!")

    def TradingIndicatorOption(request):
        assert isinstance(request, HttpRequest)

        tradeid = request.GET.get('trade_indicator_id', 0)

        tradei = models.TradeIndicator.objects.get(pk=tradeid)
        allchoices = tradelib.get_trade_all_choices(tradei)

        return render(
            request,
            'dashboard/dashboard/tradingindicatoroptions.html',
            context={
                'Ti': tradei,
                'Choice': allchoices,
            }
        )

    def EnterSignalSave(request):
        assert isinstance(request, HttpRequest)

        signal = request.GET.get('signal', 0)

        if request.user.is_authenticated:
            chartsetting = models.ChartSetting.objects.get(user=request.user)

        chartsetting = models.ChartSetting.objects.all()[0]
        chartsetting.enter_signal = signal
        chartsetting.save()

        return HttpResponse('Success Saved!')

    def Backtest(request):
        assert isinstance(request, HttpRequest)

        # backtest_id = request.GET.get('backtest_id')
        dashboard_id = request.GET.get('dashboard_id', 0)
        optmode = int(request.GET.get('optmode', 0))

        df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC' + str(dashboard_id) + '.csv', sep=',')
        df = pd.DataFrame(df)
        dates = df['Date'].tolist()

        backtests = models.Backtest.objects.filter(dashboard__id=dashboard_id)
        invalids = ValidateBacktests(backtests)
        if len(invalids) > 0:
            return JsonResponse({'state': 'error', 'value': "Please set the backtest options of " + ",".join(invalids)})

        if optmode == 0:
            actmap, result, acts = bt.get_results(df, backtests)

            html = render(
                request,
                'dashboard/dashboard/tradlabstats.html',
                context={
                    'result': result,
                }
            ).getvalue().decode("utf-8")

            html2 = render(
                request,
                'dashboard/dashboard/actmap.html',
                context={
                    'backtests': backtests,
                    'actmap': actmap,
                    'acts': acts,
                    'dates': dates,
                }
            ).getvalue().decode("utf-8")

            return JsonResponse(
                {'state': 'ok', 'actmap': actmap, 'result': result, 'acts': acts, 'html': html, 'html2': html2},
                safe=True)
        elif optmode == 1:
            actmap, result, acts, bestparams = bt.get_optresults(df, backtests)

            html = render(
                request,
                'dashboard/dashboard/tradlabstats.html',
                context={
                    'result': result,
                }
            ).getvalue().decode("utf-8")

            html1 = render(
                request,
                'dashboard/dashboard/bestparams.html',
                context={
                    'bestparams': bestparams,
                }
            ).getvalue().decode("utf-8")

            html2 = render(
                request,
                'dashboard/dashboard/actmap.html',
                context={
                    'actmap': actmap,
                    'acts': acts,
                    'dates': dates,
                    'backtests': backtests,
                }
            ).getvalue().decode("utf-8")

            return JsonResponse(
                {'state': 'ok', 'actmap': actmap, 'result': result, 'acts': acts, 'html': html, 'html1': html1,
                 'html2': html2}, safe=True)

    def SetBestParameters(request):
        assert isinstance(request, HttpRequest)

        backtest_id = request.GET.get('backtest_id')
        dashboard_id = request.GET.get('dashboard_id')

        backtest = models.Backtest.objects.get(id=backtest_id)

        if backtest.mode == 0:
            for tii in backtest.tradeindicator.tradeindicatorindicator_set.all():
                for ii in tii.indicator.indicatorinputs.all():
                    value = request.GET.get(ii.parameter)
                    set_input_value(tii, ii.parameter, value)

            if backtest.tradeindicator.backtest_mode == 1:
                tipt = models.TradeIndicatorPlotThreshold.objects.filter(
                    trade_indicator_indicator__trade_indicator=backtest.tradeindicator).first()
                tipt.threshold_b = request.GET.get('ovb')
                tipt.threshold_s = request.GET.get('ovs')
                tipt.save()

            df = pd.read_csv(settings.MEDIA_ROOT + '/labdata/OHLC' + str(dashboard_id) + '.csv', sep=',')
            df = pd.DataFrame(df)
            ti = backtest.tradeindicator
            graphs = tradelib.get_trade_plotresult(df, ti)

            return JsonResponse({'tradeid': ti.id, 'trade': graphs, 'with_main': ti.with_main}, safe=True)

    def DashboardSetting(request):
        assert isinstance(request, HttpRequest)

        if request.method == 'POST':
            # if not request.user.is_authenticated:
            #     return HttpResponse("user is not authenticated")
            dashboard_id = int(request.POST.get('dashboard_id', 0))

            # get model by dashboard id
            if dashboard_id == 0:
                # if not request.user.is_authenticated:
                #     return HttpResponse("user is not authenticated")
                # dashboard = models.Dashboard(user=request.user)
                dashboard = models.Dashboard()
            else:
                dashboard = models.Dashboard.objects.filter(id=dashboard_id).first()

            dashboard.title = request.POST.get('title', 'My Dashboard')
            dashboard.bIntraday = request.POST.get('bIntraday', 0)
            dashboard.interval = request.POST.get('interval', '15min')
            dashboard.period = request.POST.get('period', '36m')
            dashboard.symbol = request.POST.get('symbol', 'GOLD')

            dashboard.save()

            df = prd.importLiveData(dashboard)

            if df is None:
                dashboard.symbol = 'GOLD'
                dashboard.save()
                return HttpResponse('Data Importing Failed!')

            # return JsonResponse({'tradeid': ti.id, 'trade' : graphs, 'settings': settingvals, 'with_main':ti.with_main}, safe=True)
            return redirect('/' + str(dashboard.id))

        else:

            dashboard_id = int(request.GET.get('dashboard_id', 0))

            if dashboard_id == 0:
                # if not request.user.is_authenticated:
                #     return HttpResponse("user is not authenticated")
                dashboard = models.Dashboard()
            else:
                dashboard = models.Dashboard.objects.filter(id=dashboard_id).first()

        return render(
            request,
            'dashboard/dashboard/dashboardsetting.html',
            context={
                'dashboard': dashboard,
                'dashboard_id': dashboard_id,
                'Intervals': prd.INTRADAY_TIMESERIES_INTERVAL,
                'Periods': prd.HISTORICAL_TIMESERIES_PERIODS,
            }
        )

    def DeleteDashboard(request, dashboard_id):
        assert isinstance(request, HttpRequest)

        # dashboards = models.Dashboard.objects.filter(user=request.user)
        dashboard_cnt = models.Dashboard.objects.all().count()
        if dashboard_cnt == 1:
            return redirect('/' + str(dashboard_id))

        dashboard = models.Dashboard.objects.get(id=dashboard_id)
        dashboard.delete()

        return redirect('/0')

    def BacktestAttributeSave(request):
        assert isinstance(request, HttpRequest)

        backtest_id = request.GET.get('backtest_id', 0)
        attribute = request.GET.get('attribute', 0)

        backtest = models.Backtest.objects.get(id=backtest_id)
        backtest.attribute = attribute
        backtest.save()

        return HttpResponse('success')
