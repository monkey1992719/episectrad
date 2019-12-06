-- MySQL dump 10.13  Distrib 5.7.27, for Linux (x86_64)
--
-- Host: localhost    Database: episectrad
-- ------------------------------------------------------
-- Server version	5.7.27-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`) USING BTREE,
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add user',6,'add_user'),(22,'Can change user',6,'change_user'),(23,'Can delete user',6,'delete_user'),(24,'Can view user',6,'view_user'),(25,'Can add static device',7,'add_staticdevice'),(26,'Can change static device',7,'change_staticdevice'),(27,'Can delete static device',7,'delete_staticdevice'),(28,'Can view static device',7,'view_staticdevice'),(29,'Can add static token',8,'add_statictoken'),(30,'Can change static token',8,'change_statictoken'),(31,'Can delete static token',8,'delete_statictoken'),(32,'Can view static token',8,'view_statictoken'),(33,'Can add TOTP device',9,'add_totpdevice'),(34,'Can change TOTP device',9,'change_totpdevice'),(35,'Can delete TOTP device',9,'delete_totpdevice'),(36,'Can view TOTP device',9,'view_totpdevice'),(37,'Can add phone device',10,'add_phonedevice'),(38,'Can change phone device',10,'change_phonedevice'),(39,'Can delete phone device',10,'delete_phonedevice'),(40,'Can view phone device',10,'view_phonedevice'),(41,'Can add news subscription',11,'add_newssubscription'),(42,'Can change news subscription',11,'change_newssubscription'),(43,'Can delete news subscription',11,'delete_newssubscription'),(44,'Can view news subscription',11,'view_newssubscription'),(45,'Can add token metric',12,'add_tokenmetric'),(46,'Can change token metric',12,'change_tokenmetric'),(47,'Can delete token metric',12,'delete_tokenmetric'),(48,'Can view token metric',12,'view_tokenmetric'),(49,'Can add task result',13,'add_taskresult'),(50,'Can change task result',13,'change_taskresult'),(51,'Can delete task result',13,'delete_taskresult'),(52,'Can view task result',13,'view_taskresult'),(53,'Can add chart plot',14,'add_chartplot'),(54,'Can change chart plot',14,'change_chartplot'),(55,'Can delete chart plot',14,'delete_chartplot'),(56,'Can view chart plot',14,'view_chartplot'),(57,'Can add chart plot setting',15,'add_chartplotsetting'),(58,'Can change chart plot setting',15,'change_chartplotsetting'),(59,'Can delete chart plot setting',15,'delete_chartplotsetting'),(60,'Can view chart plot setting',15,'view_chartplotsetting'),(61,'Can add chart setting',16,'add_chartsetting'),(62,'Can change chart setting',16,'change_chartsetting'),(63,'Can delete chart setting',16,'delete_chartsetting'),(64,'Can view chart setting',16,'view_chartsetting'),(65,'Can add chart string',17,'add_chartstring'),(66,'Can change chart string',17,'change_chartstring'),(67,'Can delete chart string',17,'delete_chartstring'),(68,'Can view chart string',17,'view_chartstring'),(69,'Can add indicator',18,'add_indicator'),(70,'Can change indicator',18,'change_indicator'),(71,'Can delete indicator',18,'delete_indicator'),(72,'Can view indicator',18,'view_indicator'),(73,'Can add indicator input',19,'add_indicatorinput'),(74,'Can change indicator input',19,'change_indicatorinput'),(75,'Can delete indicator input',19,'delete_indicatorinput'),(76,'Can view indicator input',19,'view_indicatorinput'),(77,'Can add indicator input member ship',20,'add_indicatorinputmembership'),(78,'Can change indicator input member ship',20,'change_indicatorinputmembership'),(79,'Can delete indicator input member ship',20,'delete_indicatorinputmembership'),(80,'Can view indicator input member ship',20,'view_indicatorinputmembership'),(81,'Can add indicator input value',21,'add_indicatorinputvalue'),(82,'Can change indicator input value',21,'change_indicatorinputvalue'),(83,'Can delete indicator input value',21,'delete_indicatorinputvalue'),(84,'Can view indicator input value',21,'view_indicatorinputvalue'),(85,'Can add trade chart pattern',22,'add_tradechartpattern'),(86,'Can change trade chart pattern',22,'change_tradechartpattern'),(87,'Can delete trade chart pattern',22,'delete_tradechartpattern'),(88,'Can view trade chart pattern',22,'view_tradechartpattern'),(89,'Can add trade indicator',23,'add_tradeindicator'),(90,'Can change trade indicator',23,'change_tradeindicator'),(91,'Can delete trade indicator',23,'delete_tradeindicator'),(92,'Can view trade indicator',23,'view_tradeindicator'),(93,'Can add trade indicator cross2',24,'add_tradeindicatorcross2'),(94,'Can change trade indicator cross2',24,'change_tradeindicatorcross2'),(95,'Can delete trade indicator cross2',24,'delete_tradeindicatorcross2'),(96,'Can view trade indicator cross2',24,'view_tradeindicatorcross2'),(97,'Can add trade indicator crossv',25,'add_tradeindicatorcrossv'),(98,'Can change trade indicator crossv',25,'change_tradeindicatorcrossv'),(99,'Can delete trade indicator crossv',25,'delete_tradeindicatorcrossv'),(100,'Can view trade indicator crossv',25,'view_tradeindicatorcrossv'),(101,'Can add trade indicator indicator',26,'add_tradeindicatorindicator'),(102,'Can change trade indicator indicator',26,'change_tradeindicatorindicator'),(103,'Can delete trade indicator indicator',26,'delete_tradeindicatorindicator'),(104,'Can view trade indicator indicator',26,'view_tradeindicatorindicator'),(105,'Can add trade indicator plot threshold',27,'add_tradeindicatorplotthreshold'),(106,'Can change trade indicator plot threshold',27,'change_tradeindicatorplotthreshold'),(107,'Can delete trade indicator plot threshold',27,'delete_tradeindicatorplotthreshold'),(108,'Can view trade indicator plot threshold',27,'view_tradeindicatorplotthreshold'),(109,'Can add trade pricebar pattern',28,'add_tradepricebarpattern'),(110,'Can change trade pricebar pattern',28,'change_tradepricebarpattern'),(111,'Can delete trade pricebar pattern',28,'delete_tradepricebarpattern'),(112,'Can view trade pricebar pattern',28,'view_tradepricebarpattern'),(113,'Can add backtest',29,'add_backtest'),(114,'Can change backtest',29,'change_backtest'),(115,'Can delete backtest',29,'delete_backtest'),(116,'Can view backtest',29,'view_backtest'),(117,'Can add chart plot default setting',30,'add_chartplotdefaultsetting'),(118,'Can change chart plot default setting',30,'change_chartplotdefaultsetting'),(119,'Can delete chart plot default setting',30,'delete_chartplotdefaultsetting'),(120,'Can view chart plot default setting',30,'view_chartplotdefaultsetting'),(121,'Can add dashboard',31,'add_dashboard'),(122,'Can change dashboard',31,'change_dashboard'),(123,'Can delete dashboard',31,'delete_dashboard'),(124,'Can view dashboard',31,'view_dashboard');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backtests`
--

DROP TABLE IF EXISTS `backtests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backtests` (
  `mode` int(11) DEFAULT NULL,
  `pricebar_pattern` varchar(128) DEFAULT NULL,
  `attribute` int(11) DEFAULT NULL,
  `chart_pattern` varchar(128) DEFAULT NULL,
  `tradeindicator_id` int(11) DEFAULT NULL,
  `dashboard_id` int(11) DEFAULT NULL,
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backtests`
--

LOCK TABLES `backtests` WRITE;
/*!40000 ALTER TABLE `backtests` DISABLE KEYS */;
/*!40000 ALTER TABLE `backtests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart_plot`
--

DROP TABLE IF EXISTS `chart_plot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chart_plot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plotname` varchar(32) DEFAULT NULL,
  `plottype` varchar(30) DEFAULT NULL,
  `setting_manual` bigint(1) DEFAULT NULL,
  `indicator_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart_plot`
--

LOCK TABLES `chart_plot` WRITE;
/*!40000 ALTER TABLE `chart_plot` DISABLE KEYS */;
INSERT INTO `chart_plot` VALUES (1,'AO','histogram',0,1),(2,'acc','line',1,37),(3,'aroon_up','line',1,13),(4,'aroon_down','line',1,13),(5,'adi','line',1,14),(6,'ATR','line',1,31),(7,'cmo','line',1,2),(8,'MOM','line',1,4),(9,'CC','line',1,3),(10,'mfi_','line',1,5),(11,'PO','line',1,6),(12,'RSI','line',1,7),(13,'STOK','line',1,8),(14,'STOD','line',1,8),(15,'STCHRSI','line',1,9),(16,'TSI','line',1,10),(17,'uo','line',1,11),(18,'WPR','line',1,12),(19,'CCI','line',1,15),(20,'adx_pos','line',1,16),(21,'adx_neg','line',1,16),(22,'dema','line',1,17),(23,'hma','line',1,18),(24,'ic_a','line',1,19),(25,'ic_b','line',1,19),(26,'KST','line',1,20),(27,'SMA12','line',1,21),(28,'SMA26','line',1,21),(29,'MACD','line',1,22),(30,'MACDSig','line',1,22),(31,'mass_index','line',1,23),(32,'ema','line',1,24),(33,'sma','line',1,25),(34,'wma','line',1,26),(35,'smooth_ma','line',1,27),(36,'TRIX','line',1,28),(37,'tema','line',1,29),(38,'voi_pos','line',1,30),(39,'voi_neg','line',1,30),(40,'UPRBB','line',1,32),(41,'MIDBB','line',1,32),(42,'LWRBB','line',1,32),(43,'bb_pb','line',1,33),(44,'bb_bw','line',1,34),(45,'dc_hband','line',1,35),(46,'dc_lband','line',1,35),(47,'kc_central','line',1,36),(48,'kc_hband','line',1,36),(49,'kc_lband','line',1,36),(50,'cmf','line',1,38),(51,'ch_osc','line',1,39),(52,'eom_14','line',1,40),(53,'obv','line',1,41),(54,'PVI','line',1,42),(55,'NVI','line',1,42),(56,'vo','line',1,NULL),(57,'MACDHistogram','histogram',0,22),(58,'mfi_sma','line',1,5),(59,'mfi_high','line',1,5),(60,'mfi_mid','line',1,5),(61,'mfi_low','line',1,5),(62,'KST_SIG','line',1,20);
/*!40000 ALTER TABLE `chart_plot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart_plot_default_setting`
--

DROP TABLE IF EXISTS `chart_plot_default_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chart_plot_default_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `string_id` int(11) DEFAULT NULL,
  `color` varchar(32) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `plottype` varchar(30) DEFAULT NULL,
  `setting_manual` bigint(1) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart_plot_default_setting`
--

LOCK TABLES `chart_plot_default_setting` WRITE;
/*!40000 ALTER TABLE `chart_plot_default_setting` DISABLE KEYS */;
INSERT INTO `chart_plot_default_setting` VALUES (1,1,'#00ff00',1,'histogram',0),(2,2,'#ff9900',1,'line',1),(3,3,'#0084ff',1,'line',1),(4,4,'#ffbb00',1,'line',1),(5,5,'#ffbb00',1,'line',1),(6,6,'#992515',1,'line',1),(7,7,'#0084ff',1,'line',1),(8,8,'#92b338',1,'line',1),(9,9,'#4e93e2',1,'line',1),(10,10,'#eb6619',1,'line',1),(11,11,'#00854d',1,'line',1),(12,12,'#a200ff',1,'line',1),(13,13,'#0084ff',1,'line',1),(14,14,'#e94d0f',1,'line',1),(15,15,'#0084ff',1,'line',1),(16,16,'#0084ff',1,'line',1),(17,17,'#d10034',1,'line',1),(18,18,'#0084ff',1,'line',1),(19,19,'#836103',1,'line',1),(20,20,'#004fb6',1,'line',1),(21,21,'#eb6619',1,'line',1),(22,22,'#275515',1,'line',1),(23,23,'#450680',1,'line',1),(24,24,'#4a9144',1,'line',1),(25,25,'#ff0000',1,'line',1),(26,26,'#1e9b6b',1,'line',1),(27,27,'#ffbb00',1,'line',1),(28,28,'#ffbb00',1,'line',1),(29,29,'#497453',1,'line',1),(30,30,'#8d5869',1,'line',1),(31,31,'#5c95bb',1,'line',1),(32,32,'#32528d',1,'line',1),(33,33,'#9152f7',1,'line',1),(34,34,'#301777',1,'line',1),(35,35,'#4eaa46',1,'line',1),(36,36,'#812e3c',1,'line',1),(37,37,'#0f6127',1,'line',1),(38,38,'#4b80bd',1,'line',1),(39,39,'#d34ca6',1,'line',1),(40,40,'#28ddf5',1,'line',1),(41,41,'#578f17',1,'line',1),(42,42,'#612b13',1,'line',1),(43,43,'#375abb',1,'line',1),(44,44,'#20645b',1,'line',1),(45,45,'#1a5fb9',1,'line',1),(46,46,'#bda310',1,'line',1),(47,47,'#30b1ec',1,'line',1),(48,48,'#30b1ec',1,'line',1),(49,49,'#30b1ec',1,'line',1),(50,50,'#fa4040',1,'line',1),(51,51,'#578f17',1,'line',1),(52,52,'#578f17',1,'line',1),(53,53,'#3d3b68',1,'line',1),(54,54,'#2a6911',1,'line',1),(55,55,'#b64f3d',1,'line',1),(56,56,'#1c5c91',1,'line',1),(57,57,'#000000',1,'histogram',0),(58,58,'#a0a0a0',1,'line',1),(59,59,'#00ff00',1,'line',1),(60,60,'#a0a0a0',1,'line',1),(61,61,'#ff0000',1,'line',1),(62,62,'#c72b2b',1,'line',1);
/*!40000 ALTER TABLE `chart_plot_default_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart_plot_setting`
--

DROP TABLE IF EXISTS `chart_plot_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chart_plot_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `plot_id` int(11) DEFAULT NULL COMMENT 'one to one chart_strings',
  `color` varchar(32) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `plottype` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart_plot_setting`
--

LOCK TABLES `chart_plot_setting` WRITE;
/*!40000 ALTER TABLE `chart_plot_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `chart_plot_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart_setting`
--

DROP TABLE IF EXISTS `chart_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chart_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `symbol` varchar(16) DEFAULT NULL,
  `period` varchar(16) DEFAULT NULL,
  `interval` varchar(16) DEFAULT NULL,
  `bIntraday` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart_setting`
--

LOCK TABLES `chart_setting` WRITE;
/*!40000 ALTER TABLE `chart_setting` DISABLE KEYS */;
INSERT INTO `chart_setting` VALUES (1,NULL,'GOLD','36m','30min',1);
/*!40000 ALTER TABLE `chart_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart_strings`
--

DROP TABLE IF EXISTS `chart_strings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chart_strings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart_strings`
--

LOCK TABLES `chart_strings` WRITE;
/*!40000 ALTER TABLE `chart_strings` DISABLE KEYS */;
INSERT INTO `chart_strings` VALUES (1,'AO'),(2,'acc'),(3,'aroon_up'),(4,'aroon_down'),(5,'adi'),(6,'ATR'),(7,'cmo'),(8,'MOM'),(9,'CC'),(10,'mfi_'),(11,'PO'),(12,'RSI'),(13,'STOK'),(14,'STOD'),(15,'STCHRSI'),(16,'TSI'),(17,'uo'),(18,'WPR'),(19,'CCI'),(20,'adx_pos'),(21,'adx_neg'),(22,'dema'),(23,'hma'),(24,'ic_a'),(25,'ic_b'),(26,'KST'),(27,'SMA12'),(28,'SMA26'),(29,'MACD'),(30,'MACDSig'),(31,'mass_index'),(32,'ema'),(33,'sma'),(34,'wma'),(35,'smooth_ma'),(36,'TRIX'),(37,'tema'),(38,'voi_pos'),(39,'voi_neg'),(40,'UPRBB'),(41,'MIDBB'),(42,'LWRBB'),(43,'bb_pb'),(44,'bb_bw'),(45,'dc_hband'),(46,'dc_lband'),(47,'kc_central'),(48,'kc_hband'),(49,'kc_lband'),(50,'cmf'),(51,'ch_osc'),(52,'eom_14'),(53,'obv'),(54,'PVI'),(55,'NVI'),(56,'vo'),(57,'MACDHistogram'),(58,'mfi_sma'),(59,'mfi_high'),(60,'mfi_mid'),(61,'mfi_low'),(62,'KST_SIG');
/*!40000 ALTER TABLE `chart_strings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_newssubscription`
--

DROP TABLE IF EXISTS `core_newssubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_newssubscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime(6) NOT NULL,
  `email` varchar(254) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_newssubscription`
--

LOCK TABLES `core_newssubscription` WRITE;
/*!40000 ALTER TABLE `core_newssubscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_newssubscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_tokenmetric`
--

DROP TABLE IF EXISTS `core_tokenmetric`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_tokenmetric` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime(6) NOT NULL,
  `rank` int(11) NOT NULL,
  `price_usd` decimal(12,7) NOT NULL,
  `price_btc` decimal(24,16) NOT NULL,
  `day_volume_usd` decimal(12,2) NOT NULL,
  `market_cap_usd` decimal(12,2) NOT NULL,
  `available_supply` decimal(24,8) NOT NULL,
  `total_supply` decimal(24,8) NOT NULL,
  `percent_change_1h` decimal(12,2) NOT NULL,
  `percent_change_24h` decimal(12,2) NOT NULL,
  `percent_change_7d` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_tokenmetric`
--

LOCK TABLES `core_tokenmetric` WRITE;
/*!40000 ALTER TABLE `core_tokenmetric` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_tokenmetric` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard_indicatorinput`
--

DROP TABLE IF EXISTS `dashboard_indicatorinput`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard_indicatorinput` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard_indicatorinput`
--

LOCK TABLES `dashboard_indicatorinput` WRITE;
/*!40000 ALTER TABLE `dashboard_indicatorinput` DISABLE KEYS */;
INSERT INTO `dashboard_indicatorinput` VALUES (1,'aa'),(2,'bb'),(3,'cc'),(34,'aa'),(35,'bb'),(36,'cc'),(37,'aa'),(38,'bb'),(39,'cc'),(40,'aa'),(41,'bb'),(42,'cc');
/*!40000 ALTER TABLE `dashboard_indicatorinput` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard_user`
--

DROP TABLE IF EXISTS `dashboard_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `email` varchar(254) NOT NULL,
  `email_confirmed` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard_user`
--

LOCK TABLES `dashboard_user` WRITE;
/*!40000 ALTER TABLE `dashboard_user` DISABLE KEYS */;
INSERT INTO `dashboard_user` VALUES (20,'pbkdf2_sha256$120000$TdfwgpppkvCq$Pz8SUV/cMDvJseHtFnJCATg62q8vvsleVciXxKKoo5U=',NULL,0,'kss_alexander@outlook.com',0,0,1,'2019-01-31 18:01:54.947472');
/*!40000 ALTER TABLE `dashboard_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard_user_groups`
--

DROP TABLE IF EXISTS `dashboard_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `dashboard_user_groups_user_id_group_id_2c570fca_uniq` (`user_id`,`group_id`) USING BTREE,
  KEY `dashboard_user_groups_group_id_54086039_fk_auth_group_id` (`group_id`) USING BTREE,
  CONSTRAINT `dashboard_user_groups_group_id_54086039_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `dashboard_user_groups_user_id_a915c7fc_fk_dashboard_user_id` FOREIGN KEY (`user_id`) REFERENCES `dashboard_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard_user_groups`
--

LOCK TABLES `dashboard_user_groups` WRITE;
/*!40000 ALTER TABLE `dashboard_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `dashboard_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard_user_user_permissions`
--

DROP TABLE IF EXISTS `dashboard_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `dashboard_user_user_perm_user_id_permission_id_550d0c70_uniq` (`user_id`,`permission_id`) USING BTREE,
  KEY `dashboard_user_user__permission_id_70269958_fk_auth_perm` (`permission_id`) USING BTREE,
  CONSTRAINT `dashboard_user_user__permission_id_70269958_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `dashboard_user_user__user_id_ea9b20c2_fk_dashboard` FOREIGN KEY (`user_id`) REFERENCES `dashboard_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard_user_user_permissions`
--

LOCK TABLES `dashboard_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `dashboard_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `dashboard_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboards`
--

DROP TABLE IF EXISTS `dashboards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `symbol` varchar(255) DEFAULT 'GOLD',
  `period` varchar(255) DEFAULT '36m',
  `interval` varchar(16) DEFAULT '15min',
  `bIntraday` int(11) DEFAULT '0',
  `enter_signal` int(11) DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboards`
--

LOCK TABLES `dashboards` WRITE;
/*!40000 ALTER TABLE `dashboards` DISABLE KEYS */;
INSERT INTO `dashboards` VALUES (1,'GOLD','36m','1min',1,0,'My Dashboard',NULL);
/*!40000 ALTER TABLE `dashboards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`) USING BTREE,
  KEY `django_admin_log_user_id_c564eba6_fk_dashboard_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_dashboard_user_id` FOREIGN KEY (`user_id`) REFERENCES `dashboard_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_celery_results_taskresult`
--

DROP TABLE IF EXISTS `django_celery_results_taskresult`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_celery_results_taskresult` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL,
  `content_type` varchar(128) NOT NULL,
  `content_encoding` varchar(64) NOT NULL,
  `result` longtext,
  `date_done` datetime(6) NOT NULL,
  `traceback` longtext,
  `hidden` tinyint(1) NOT NULL,
  `meta` longtext,
  `task_args` longtext,
  `task_kwargs` longtext,
  `task_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `task_id` (`task_id`) USING BTREE,
  KEY `django_celery_results_taskresult_hidden_cd77412f` (`hidden`) USING BTREE,
  KEY `django_celery_results_taskresult_date_done_49edada6` (`date_done`),
  KEY `django_celery_results_taskresult_status_cbbed23a` (`status`),
  KEY `django_celery_results_taskresult_task_name_90987df3` (`task_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_celery_results_taskresult`
--

LOCK TABLES `django_celery_results_taskresult` WRITE;
/*!40000 ALTER TABLE `django_celery_results_taskresult` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_celery_results_taskresult` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'contenttypes','contenttype'),(11,'core','newssubscription'),(12,'core','tokenmetric'),(29,'dashboard','backtest'),(14,'dashboard','chartplot'),(30,'dashboard','chartplotdefaultsetting'),(15,'dashboard','chartplotsetting'),(16,'dashboard','chartsetting'),(17,'dashboard','chartstring'),(31,'dashboard','dashboard'),(18,'dashboard','indicator'),(19,'dashboard','indicatorinput'),(20,'dashboard','indicatorinputmembership'),(21,'dashboard','indicatorinputvalue'),(22,'dashboard','tradechartpattern'),(23,'dashboard','tradeindicator'),(24,'dashboard','tradeindicatorcross2'),(25,'dashboard','tradeindicatorcrossv'),(26,'dashboard','tradeindicatorindicator'),(27,'dashboard','tradeindicatorplotthreshold'),(28,'dashboard','tradepricebarpattern'),(6,'dashboard','user'),(13,'django_celery_results','taskresult'),(7,'otp_static','staticdevice'),(8,'otp_static','statictoken'),(9,'otp_totp','totpdevice'),(5,'sessions','session'),(10,'two_factor','phonedevice');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2019-01-29 00:01:16.511327'),(2,'contenttypes','0002_remove_content_type_name','2019-01-29 00:01:17.311175'),(3,'auth','0001_initial','2019-01-29 00:01:18.060586'),(4,'auth','0002_alter_permission_name_max_length','2019-01-29 00:01:18.196734'),(5,'auth','0003_alter_user_email_max_length','2019-01-29 00:01:18.206706'),(6,'auth','0004_alter_user_username_opts','2019-01-29 00:01:18.218698'),(7,'auth','0005_alter_user_last_login_null','2019-01-29 00:01:18.227650'),(8,'auth','0006_require_contenttypes_0002','2019-01-29 00:01:18.234603'),(9,'auth','0007_alter_validators_add_error_messages','2019-01-29 00:01:18.243580'),(10,'auth','0008_alter_user_username_max_length','2019-01-29 00:01:18.252586'),(11,'auth','0009_alter_user_last_name_max_length','2019-01-29 00:01:18.262529'),(12,'dashboard','0001_initial','2019-01-29 00:01:19.664668'),(13,'admin','0001_initial','2019-01-29 00:01:20.151055'),(14,'admin','0002_logentry_remove_auto_add','2019-01-29 00:01:20.175696'),(15,'admin','0003_logentry_add_action_flag_choices','2019-01-29 00:01:20.207833'),(16,'otp_static','0001_initial','2019-01-29 00:01:20.905689'),(17,'otp_totp','0001_initial','2019-01-29 00:01:21.233950'),(18,'sessions','0001_initial','2019-01-29 00:01:21.441146'),(19,'two_factor','0001_initial','2019-01-29 00:01:21.768020'),(20,'two_factor','0002_auto_20150110_0810','2019-01-29 00:01:21.793787'),(21,'two_factor','0003_auto_20150817_1733','2019-01-29 00:01:21.829228'),(22,'two_factor','0004_auto_20160205_1827','2019-01-29 00:01:21.932509'),(23,'two_factor','0005_auto_20160224_0450','2019-01-29 00:01:22.069277'),(24,'core','0001_initial','2019-01-29 10:51:50.354898'),(25,'core','0002_tokenmetric','2019-01-29 10:51:50.413847'),(26,'core','0003_rate_precision','2019-01-29 10:51:50.536947'),(27,'dashboard','0002_remove_user_username','2019-01-29 10:52:42.349147'),(28,'django_celery_results','0001_initial','2019-01-30 18:28:10.649900'),(29,'django_celery_results','0002_add_task_name_args_kwargs','2019-01-30 18:28:10.869294'),(30,'django_celery_results','0003_auto_20181106_1101','2019-01-30 18:28:10.881260'),(31,'dashboard','0003_auto_20190308_0905','2019-03-08 01:19:16.467906'),(32,'dashboard','0004_auto_20190308_0930','2019-03-08 01:32:34.420381'),(33,'dashboard','0005_auto_20190308_1636','2019-03-08 08:36:36.912388'),(34,'dashboard','0006_auto_20190308_1640','2019-03-08 08:42:15.694023'),(35,'dashboard','0003_auto_20190308_1645','2019-03-08 08:47:41.451104'),(36,'django_celery_results','0004_auto_20190516_0412','2019-11-06 11:18:22.773329');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  KEY `django_session_expire_date_a5c62663` (`expire_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('01ykfgdasa9hydvea3bv0uax5a0y8ruj','YjAwYTJlOWZhOTlhYTM2ZGQyZDRlYWNiZjQ3MjZiMzYwNThhNWY5NDp7IndpemFyZF9sb2dpbl92aWV3Ijp7InN0ZXAiOiJhdXRoIiwic3RlcF9kYXRhIjp7fSwic3RlcF9maWxlcyI6e30sImV4dHJhX2RhdGEiOnt9LCJ2YWxpZGF0ZWRfc3RlcF9kYXRhIjp7fX19','2019-02-12 09:34:08.969533'),('pcsxoedy7sphj8fumb0r3zx340poknz6','YjAwYTJlOWZhOTlhYTM2ZGQyZDRlYWNiZjQ3MjZiMzYwNThhNWY5NDp7IndpemFyZF9sb2dpbl92aWV3Ijp7InN0ZXAiOiJhdXRoIiwic3RlcF9kYXRhIjp7fSwic3RlcF9maWxlcyI6e30sImV4dHJhX2RhdGEiOnt9LCJ2YWxpZGF0ZWRfc3RlcF9kYXRhIjp7fX19','2019-02-12 09:06:11.687290'),('su6dkt0m57qgy3nqj3yx86walokposez','MGU1OGZhYmE4ZTM0NjE2Nzk0NzhlYmI1MGE5YWM5OTQyOTVmNWM2ZTp7IndpemFyZF9sb2dpbl92aWV3Ijp7InN0ZXAiOiJhdXRoIiwic3RlcF9kYXRhIjp7fSwic3RlcF9maWxlcyI6e30sImV4dHJhX2RhdGEiOnt9LCJ2YWxpZGF0ZWRfc3RlcF9kYXRhIjp7fX0sIl9hdXRoX3VzZXJfaWQiOiIxMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMzcxNTk2ZDE4N2M3ZjVhMGIwMGMxMDAyNWViZTA4MjAyYTMxMjFjNyJ9','2019-02-14 09:18:12.906946');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indicator_input`
--

DROP TABLE IF EXISTS `indicator_input`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indicator_input` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(256) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indicator_input`
--

LOCK TABLES `indicator_input` WRITE;
/*!40000 ALTER TABLE `indicator_input` DISABLE KEYS */;
/*!40000 ALTER TABLE `indicator_input` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indicator_input_value`
--

DROP TABLE IF EXISTS `indicator_input_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indicator_input_value` (
  `id` int(11) NOT NULL,
  `trade_indicator_indicator_id` int(11) DEFAULT NULL,
  `indicator_input_id` int(11) DEFAULT NULL,
  `value` float(255,0) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indicator_input_value`
--

LOCK TABLES `indicator_input_value` WRITE;
/*!40000 ALTER TABLE `indicator_input_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `indicator_input_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indicators`
--

DROP TABLE IF EXISTS `indicators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `id_letter` varchar(32) NOT NULL,
  `category` varchar(32) NOT NULL,
  `value_indicator` int(11) NOT NULL,
  `possible_combine` int(11) NOT NULL,
  `combine_main` varchar(45) DEFAULT NULL,
  `param_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indicators`
--

LOCK TABLES `indicators` WRITE;
/*!40000 ALTER TABLE `indicators` DISABLE KEYS */;
INSERT INTO `indicators` VALUES (1,'Awesome Oscillator','ao','Momentum',0,0,NULL,NULL),(2,'Chande Momentum Oscillator','cmo','Momentum',1,0,NULL,NULL),(3,'Coppock Curve','cc','Momentum',0,0,NULL,NULL),(4,'Momentum','mom','Momentum',0,0,NULL,NULL),(5,'Money Flow Index','mfi','Momentum',1,0,NULL,NULL),(6,'Price Oscillator','po','Momentum',0,1,NULL,NULL),(7,'Relative Strength Index','rsi','Momentum',0,1,NULL,NULL),(8,'Stochastic','stoch','Momentum',0,0,NULL,NULL),(9,'Stochastic RSI','stchrsi','Momentum',0,1,NULL,NULL),(10,'True Strength Index','tsi','Momentum',0,0,NULL,NULL),(11,'Ultimate Oscillator','uo','Momentum',1,0,NULL,NULL),(12,'Williams % R','wpr','Momentum',0,1,NULL,NULL),(13,'Aroon','aroon','Trend',1,0,NULL,NULL),(14,'Average Directional Index','adi','Trend',1,0,NULL,NULL),(15,'Commodity Channel Index','cci','Trend',0,0,NULL,NULL),(16,'Directional Movement Index','dmi','Trend',0,0,NULL,NULL),(17,'Double Exponential Moving Avearge','dema','Trend',1,0,NULL,NULL),(18,'Hull MA','hma','Trend',1,1,NULL,NULL),(19,'Ichimoku Cloud','ic','Trend',1,0,NULL,NULL),(20,'Know Sure Thing (KST) Oscillator','kst','Trend',0,0,NULL,NULL),(21,'MA Cross','macross','Trend',0,0,NULL,NULL),(22,'MACD','macd','Trend',0,1,NULL,NULL),(23,'Mass Index','mi','Trend',1,0,NULL,NULL),(24,'Moving Average Exponential','ema','Trend',1,1,NULL,NULL),(25,'Moving Average Simple','sma','Trend',1,0,NULL,NULL),(26,'Moving Average Weighted','wma','Trend',1,1,NULL,NULL),(27,'Smoothed Moving Average','smma','Trend',1,1,NULL,NULL),(28,'TRIX','trix','Trend',0,0,NULL,NULL),(29,'Triple EMA','tema','Trend',1,0,NULL,NULL),(30,'Vortex Indicator','voi','Trend',0,0,NULL,NULL),(31,'Average True Range','atr','Volatility',0,0,NULL,NULL),(32,'Bollinger Bands','bb','Volatility',0,1,NULL,NULL),(33,'Bollinger Bands % B','bb_pb','Volatility',1,0,NULL,NULL),(34,'Bollinger Bands Width','bb_bw','Volatility',1,0,NULL,NULL),(35,'Donchian Channels','dc','Volatility',1,0,NULL,NULL),(36,'Keltner Channels','kc','Volatility',0,1,NULL,NULL),(37,'Accumulation Distribution Index','acc','Volume',1,0,NULL,NULL),(38,'Chaikin Money Flow','cmf','Volume',1,0,NULL,NULL),(39,'Chaikin Oscillator','co','Volume',1,0,NULL,NULL),(40,'Ease of Movement','eom','Volume',1,0,NULL,NULL),(41,'On Balance Volume','obv','Volume',1,0,NULL,NULL),(42,'Volume','volume','Volume',1,0,NULL,NULL);
/*!40000 ALTER TABLE `indicators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indicators1`
--

DROP TABLE IF EXISTS `indicators1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indicators1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `id_letter` varchar(32) DEFAULT NULL,
  `category` varchar(32) DEFAULT NULL,
  `value_indicator` int(1) DEFAULT NULL,
  `possible_combine` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indicators1`
--

LOCK TABLES `indicators1` WRITE;
/*!40000 ALTER TABLE `indicators1` DISABLE KEYS */;
INSERT INTO `indicators1` VALUES (1,'Awesome Oscillator','ao','Momentum',0,NULL),(2,'Chande Momentum Oscillator','cmo','Momentum',1,0),(3,'Coppock Curve','cc','Momentum',0,NULL),(4,'Momentum','mom','Momentum',0,0),(5,'Money Flow Index','mfi','Momentum',1,NULL),(6,'Price Oscillator','po','Momentum',0,1),(7,'Relative Strength Index','rsi','Momentum',0,1),(8,'Stochastic','stoch','Momentum',0,NULL),(9,'Stochastic RSI','stchrsi','Momentum',0,1),(10,'True Strength Index','tsi','Momentum',0,NULL),(11,'Ultimate Oscillator','uo','Momentum',1,NULL),(12,'Williams % R','wpr','Momentum',0,1),(13,'Aroon','aroon','Trend',1,NULL),(14,'Average Directional Index','adi','Trend',1,NULL),(15,'Commodity Channel Index','cci','Trend',0,0),(16,'Directional Movement Index','dmi','Trend',0,NULL),(17,'Double Exponential Moving Avearge','dema','Trend',1,NULL),(18,'Hull MA','hma','Trend',1,1),(19,'Ichimoku Cloud','ic','Trend',1,NULL),(20,'Know Sure Thing (KST) Oscillator','kst','Trend',0,NULL),(21,'MA Cross','macross','Trend',0,NULL),(22,'MACD','macd','Trend',0,1),(23,'Mass Index','mi','Trend',1,NULL),(24,'Moving Average Exponential','ema','Trend',1,1),(25,'Moving Average Simple','sma','Trend',1,NULL),(26,'Moving Average Weighted','wma','Trend',1,1),(27,'Smoothed Moving Average','smma','Trend',1,1),(28,'TRIX','trix','Trend',0,NULL),(29,'Triple EMA','tema','Trend',1,NULL),(30,'Vortex Indicator','voi','Trend',0,NULL),(31,'Average True Range','atr','Volatility',0,NULL),(32,'Bollinger Bands','bb','Volatility',0,1),(33,'Bollinger Bands % B','bb_pb','Volatility',1,0),(34,'Bollinger Bands Width','bb_bw','Volatility',1,0),(35,'Donchian Channels','dc','Volatility',1,NULL),(36,'Keltner Channels','kc','Volatility',0,1),(37,'Accumulation Distribution Index','acc','Volume',1,NULL),(38,'Chaikin Money Flow','cmf','Volume',1,NULL),(39,'Chaikin Oscillator','co','Volume',1,NULL),(40,'Ease of Movement','eom','Volume',1,NULL),(41,'On Balance Volume','obv','Volume',1,NULL),(42,'Volume','volume','Volume',1,NULL);
/*!40000 ALTER TABLE `indicators1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indicators_indicatorinputs`
--

DROP TABLE IF EXISTS `indicators_indicatorinputs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indicators_indicatorinputs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `indicator_id` int(11) NOT NULL,
  `indicatorinput_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `indicators_indicatorinpu_indicator_id_indicatorin_649ea465_uniq` (`indicator_id`,`indicatorinput_id`) USING BTREE,
  KEY `indicators_indicator_indicatorinput_id_4b2534a8_fk_indicator` (`indicatorinput_id`) USING BTREE,
  CONSTRAINT `indicators_indicator_indicator_id_0766593b_fk_indicator` FOREIGN KEY (`indicator_id`) REFERENCES `indicators` (`id`),
  CONSTRAINT `indicators_indicator_indicatorinput_id_4b2534a8_fk_indicator` FOREIGN KEY (`indicatorinput_id`) REFERENCES `indicator_input` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indicators_indicatorinputs`
--

LOCK TABLES `indicators_indicatorinputs` WRITE;
/*!40000 ALTER TABLE `indicators_indicatorinputs` DISABLE KEYS */;
/*!40000 ALTER TABLE `indicators_indicatorinputs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_static_staticdevice`
--

DROP TABLE IF EXISTS `otp_static_staticdevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `otp_static_staticdevice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `confirmed` tinyint(1) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `otp_static_staticdevice_user_id_7f9cff2b_fk_dashboard_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `otp_static_staticdevice_user_id_7f9cff2b_fk_dashboard_user_id` FOREIGN KEY (`user_id`) REFERENCES `dashboard_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_static_staticdevice`
--

LOCK TABLES `otp_static_staticdevice` WRITE;
/*!40000 ALTER TABLE `otp_static_staticdevice` DISABLE KEYS */;
/*!40000 ALTER TABLE `otp_static_staticdevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_static_statictoken`
--

DROP TABLE IF EXISTS `otp_static_statictoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `otp_static_statictoken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(16) NOT NULL,
  `device_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `otp_static_statictok_device_id_74b7c7d1_fk_otp_stati` (`device_id`) USING BTREE,
  KEY `otp_static_statictoken_token_d0a51866` (`token`) USING BTREE,
  CONSTRAINT `otp_static_statictok_device_id_74b7c7d1_fk_otp_stati` FOREIGN KEY (`device_id`) REFERENCES `otp_static_staticdevice` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_static_statictoken`
--

LOCK TABLES `otp_static_statictoken` WRITE;
/*!40000 ALTER TABLE `otp_static_statictoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `otp_static_statictoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_totp_totpdevice`
--

DROP TABLE IF EXISTS `otp_totp_totpdevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `otp_totp_totpdevice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `confirmed` tinyint(1) NOT NULL,
  `key` varchar(80) NOT NULL,
  `step` smallint(5) unsigned NOT NULL,
  `t0` bigint(20) NOT NULL,
  `digits` smallint(5) unsigned NOT NULL,
  `tolerance` smallint(5) unsigned NOT NULL,
  `drift` smallint(6) NOT NULL,
  `last_t` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `otp_totp_totpdevice_user_id_0fb18292_fk_dashboard_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `otp_totp_totpdevice_user_id_0fb18292_fk_dashboard_user_id` FOREIGN KEY (`user_id`) REFERENCES `dashboard_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_totp_totpdevice`
--

LOCK TABLES `otp_totp_totpdevice` WRITE;
/*!40000 ALTER TABLE `otp_totp_totpdevice` DISABLE KEYS */;
/*!40000 ALTER TABLE `otp_totp_totpdevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_chart_pattern`
--

DROP TABLE IF EXISTS `trade_chart_pattern`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_chart_pattern` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `chart_pattern` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_chart_pattern`
--

LOCK TABLES `trade_chart_pattern` WRITE;
/*!40000 ALTER TABLE `trade_chart_pattern` DISABLE KEYS */;
/*!40000 ALTER TABLE `trade_chart_pattern` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_indicator`
--

DROP TABLE IF EXISTS `trade_indicator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_indicator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `trade_mode` int(2) DEFAULT NULL COMMENT '0: original way 1: threshold 2: cross',
  `with_main` int(2) DEFAULT NULL,
  `backtest_mode` int(11) DEFAULT NULL,
  `signal` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_indicator`
--

LOCK TABLES `trade_indicator` WRITE;
/*!40000 ALTER TABLE `trade_indicator` DISABLE KEYS */;
INSERT INTO `trade_indicator` VALUES (1,NULL,0,0,NULL,NULL);
/*!40000 ALTER TABLE `trade_indicator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_indicator_cross2`
--

DROP TABLE IF EXISTS `trade_indicator_cross2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_indicator_cross2` (
  `id` int(11) NOT NULL,
  `trade_indicator_indicator1_id` int(11) DEFAULT NULL,
  `chart_plot1_id` int(11) DEFAULT NULL,
  `trade_indicator_indicator2_id` int(11) DEFAULT NULL,
  `chart_plot2_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_indicator_cross2`
--

LOCK TABLES `trade_indicator_cross2` WRITE;
/*!40000 ALTER TABLE `trade_indicator_cross2` DISABLE KEYS */;
/*!40000 ALTER TABLE `trade_indicator_cross2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_indicator_crossv`
--

DROP TABLE IF EXISTS `trade_indicator_crossv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_indicator_crossv` (
  `id` int(11) NOT NULL,
  `trade_indicator_indicator_id` int(11) DEFAULT NULL,
  `chart_plot_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_indicator_crossv`
--

LOCK TABLES `trade_indicator_crossv` WRITE;
/*!40000 ALTER TABLE `trade_indicator_crossv` DISABLE KEYS */;
/*!40000 ALTER TABLE `trade_indicator_crossv` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_indicator_indicator`
--

DROP TABLE IF EXISTS `trade_indicator_indicator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_indicator_indicator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trade_indicator_id` int(11) DEFAULT NULL,
  `indicator_id` int(11) DEFAULT NULL,
  `traditional` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_indicator_indicator`
--

LOCK TABLES `trade_indicator_indicator` WRITE;
/*!40000 ALTER TABLE `trade_indicator_indicator` DISABLE KEYS */;
INSERT INTO `trade_indicator_indicator` VALUES (1,1,1,NULL);
/*!40000 ALTER TABLE `trade_indicator_indicator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_indicator_plot_threshold`
--

DROP TABLE IF EXISTS `trade_indicator_plot_threshold`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_indicator_plot_threshold` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trade_indicator_indicator_id` int(11) DEFAULT NULL,
  `plot_id` int(11) DEFAULT NULL,
  `threshold` float(11,0) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_indicator_plot_threshold`
--

LOCK TABLES `trade_indicator_plot_threshold` WRITE;
/*!40000 ALTER TABLE `trade_indicator_plot_threshold` DISABLE KEYS */;
/*!40000 ALTER TABLE `trade_indicator_plot_threshold` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_pricebar_pattern`
--

DROP TABLE IF EXISTS `trade_pricebar_pattern`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_pricebar_pattern` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `pricebar_pattern` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_pricebar_pattern`
--

LOCK TABLES `trade_pricebar_pattern` WRITE;
/*!40000 ALTER TABLE `trade_pricebar_pattern` DISABLE KEYS */;
/*!40000 ALTER TABLE `trade_pricebar_pattern` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `two_factor_phonedevice`
--

DROP TABLE IF EXISTS `two_factor_phonedevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `two_factor_phonedevice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `confirmed` tinyint(1) NOT NULL,
  `number` varchar(128) NOT NULL,
  `key` varchar(40) NOT NULL,
  `method` varchar(4) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `two_factor_phonedevice_user_id_54718003_fk_dashboard_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `two_factor_phonedevice_user_id_54718003_fk_dashboard_user_id` FOREIGN KEY (`user_id`) REFERENCES `dashboard_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `two_factor_phonedevice`
--

LOCK TABLES `two_factor_phonedevice` WRITE;
/*!40000 ALTER TABLE `two_factor_phonedevice` DISABLE KEYS */;
/*!40000 ALTER TABLE `two_factor_phonedevice` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-08 20:16:52
