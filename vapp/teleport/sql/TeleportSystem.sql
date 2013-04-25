-- MySQL dump 10.13  Distrib 5.2.4-MariaDB, for suse-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: TeleportSystem
-- ------------------------------------------------------
-- Server version	5.2.4-MariaDB-log

--
-- Table structure for table `Destinations`
--

DROP TABLE IF EXISTS `Destinations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Destinations` (
  `Category` varchar(9) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Name` varchar(9) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TargetRegion` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TargetLanding` varchar(24) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TargetLookat` varchar(24) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dump completed on 2011-06-08  1:12:56
