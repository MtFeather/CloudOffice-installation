-- MySQL dump 10.14  Distrib 5.5.56-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: nodejs
-- ------------------------------------------------------
-- Server version	5.5.56-MariaDB

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
-- Table structure for table `back_img`
--

DROP TABLE IF EXISTS `back_img`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `back_img` (
  `bid` int(11) NOT NULL AUTO_INCREMENT,
  `eid` int(11) DEFAULT NULL,
  `oid` int(11) DEFAULT NULL,
  `back_status` int(11) DEFAULT NULL,
  `create_date` timestamp NULL DEFAULT NULL,
  `last_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `empdata`
--

DROP TABLE IF EXISTS `empdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `empdata` (
  `eid` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(20) NOT NULL,
  `password` varchar(40) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `sex` varchar(2) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `join_time` timestamp NULL DEFAULT NULL,
  `last_time` timestamp NULL DEFAULT NULL,
  `verify` int(11) DEFAULT NULL,
  PRIMARY KEY (`eid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `nid` int(11) NOT NULL AUTO_INCREMENT,
  `eid` int(11) DEFAULT NULL,
  `subject` varchar(40) DEFAULT NULL,
  `content` text,
  `post_date` timestamp NULL DEFAULT NULL,
  `edit_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ori_xml`
--

DROP TABLE IF EXISTS `ori_xml`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ori_xml` (
  `oid` int(11) NOT NULL AUTO_INCREMENT,
  `hd_name` varchar(100) DEFAULT NULL,
  `hd_path` varchar(12) DEFAULT NULL,
  `eid` int(11) DEFAULT NULL,
  `hd_size` int(11) DEFAULT NULL,
  `hd_cpu` int(11) DEFAULT NULL,
  `hd_ram` int(11) DEFAULT NULL,
  `restore` int(11) DEFAULT NULL,
  `hd_status` int(11) DEFAULT NULL,
  `disable` int(11) DEFAULT NULL,
  `create_date` timestamp NULL DEFAULT NULL,
  `last_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_control`
--

DROP TABLE IF EXISTS `system_control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_control` (
  `project` varchar(255) NOT NULL,
  `option` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`project`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_control`
--

LOCK TABLES `system_control` WRITE;
/*!40000 ALTER TABLE `system_control` DISABLE KEYS */;
INSERT INTO `system_control` VALUES ('idle_time','72'),('login','yes'),('max_disk','500'),('max_ram','8'),('register','no'),('usb','yes'),('version','cloudoffice.v1.0.0_20200905');
/*!40000 ALTER TABLE `system_control` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_xml`
--

DROP TABLE IF EXISTS `user_xml`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_xml` (
  `eid` int(11) NOT NULL,
  `user_uuid` varchar(36) DEFAULT NULL,
  `oid` int(11) DEFAULT NULL,
  `user_mac1` varchar(17) DEFAULT NULL,
  `user_mac2` varchar(17) DEFAULT NULL,
  `user_port` varchar(5) DEFAULT NULL,
  `user_ip` varchar(15) DEFAULT NULL,
  `user_cdrom` varchar(100) DEFAULT NULL,
  `broadcast` int(11) DEFAULT NULL,
  PRIMARY KEY (`eid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-09 21:13:21
