-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: db_test
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.21-MariaDB

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
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_number` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (4,'sd');
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip`
--

DROP TABLE IF EXISTS `ip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(15) DEFAULT NULL,
  `internetaccess` tinyint(1) DEFAULT '1',
  `networkdevice_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `networkdevice_id_idx` (`networkdevice_id`),
  CONSTRAINT `networkdevice_id` FOREIGN KEY (`networkdevice_id`) REFERENCES `networkdevice` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip`
--

LOCK TABLES `ip` WRITE;
/*!40000 ALTER TABLE `ip` DISABLE KEYS */;
INSERT INTO `ip` VALUES (3,'DHCP',1,2);
/*!40000 ALTER TABLE `ip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_changes`
--

DROP TABLE IF EXISTS `ip_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `networkdevice_id` int(11) DEFAULT NULL,
  `ip_id` int(11) DEFAULT NULL,
  `comment` varchar(45) DEFAULT NULL,
  `changed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index1` (`networkdevice_id`,`ip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_changes`
--

LOCK TABLES `ip_changes` WRITE;
/*!40000 ALTER TABLE `ip_changes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `networkdevice`
--

DROP TABLE IF EXISTS `networkdevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `networkdevice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `network_name` varchar(45) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `networkdevicetype_id` int(11) NOT NULL,
  `cpu` varchar(45) DEFAULT NULL,
  `ram` varchar(45) DEFAULT NULL,
  `mainboard` varchar(45) DEFAULT NULL,
  `ram_details` varchar(45) DEFAULT NULL,
  `description` varchar(45) NOT NULL,
  `bought_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inventory_id_idx` (`inventory_id`),
  CONSTRAINT `inventory_id` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `networkdevice`
--

LOCK TABLES `networkdevice` WRITE;
/*!40000 ALTER TABLE `networkdevice` DISABLE KEYS */;
INSERT INTO `networkdevice` VALUES (2,'ef',4,1,'dsf','sdf','dsf','DDR3-2133,PC3-17000,ECC','todo','2017-02-01 02:09:00');
/*!40000 ALTER TABLE `networkdevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `networkdevicetype`
--

DROP TABLE IF EXISTS `networkdevicetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `networkdevicetype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `networkdevicetype`
--

LOCK TABLES `networkdevicetype` WRITE;
/*!40000 ALTER TABLE `networkdevicetype` DISABLE KEYS */;
INSERT INTO `networkdevicetype` VALUES (1,'Server','Running 24/7; Deploying functionalities'),(2,'Portable PCs','Notebooks, Labtops etc.'),(3,'Fixed Desktop','Desktop Tower PCs'),(4,'Switch',NULL);
/*!40000 ALTER TABLE `networkdevicetype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'user',NULL),(2,'superuser',NULL);
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `roles_users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (1,1),(1,2),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1);
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Admin',NULL,'admin','$pbkdf2-sha512$25000$.x8j5NwbAyBEiNE6p9Q6Bw$z8G/K5.2eaEhIJtoKQK3L9bz/tZgoNw/ppofRUzKI316GNNIrcnMLQIxDvCTU99GMJAS87CIcs3wR0Mpmop3ww',1,NULL),(2,'Harry','Brown','harry.brown@example.com','$pbkdf2-sha512$25000$lxJijDEmZCyF0Lr3fq8Vog$VKTHhHeERt.IRLfMr4qPtWKQyjP8euChcWaOMzdupwsj7qsGN3QAE7qBpaG8alNVJnGgx/uOQKHzmcjoUNHChA',1,NULL),(3,'Amelia','Smith','amelia.smith@example.com','$pbkdf2-sha512$25000$6J3TGqNUaq0VYgwBACCEkA$1cek32nxeK6rI.AwX5DD2DyjvJZZ2GIUWNVbffqAedCWkUTHvNhL9yiXpksQAjfAhk4oxMB/ko3.BZ05DrySBA',1,NULL),(4,'Oliver','Patel','oliver.patel@example.com','$pbkdf2-sha512$25000$wri31hoDoJRSqnXuXYuxFg$huPLvT9abeUXiKZvnafFUHN473FVwvwwnHZYIVQV0Sh0j/nAjQD0CWFYTmm8pHW0.w2aPt6t2InN0ymYUR1CSA',1,NULL),(5,'Jack','Jones','jack.jones@example.com','$pbkdf2-sha512$25000$Vuqd0xrDOMd4jxHC2FtrbQ$jMCXP72FKxLKa870nh3YBYye9oVN5tErPix24tthDv49UmMMcpUk/vmWYSkjDSc3mQEfDEYngFPvPGnXbLpnOA',1,NULL),(6,'Isabella','Williams','isabella.williams@example.com','$pbkdf2-sha512$25000$XIvR.v8/R6iV8n7vfU.pVQ$MuvqBWSYwajDGcWM7gL3.I6eai1t3dJ1/vJCg7iIK0/7V0LwjFUh1zbFf7IcUG1YPF5.wuGPjUnusqnN7wVfrw',1,NULL),(7,'Charlie','Johnson','charlie.johnson@example.com','$pbkdf2-sha512$25000$IAQgRKj1nlNqjbF2bk2pNQ$Dj3TzjMhpHakiPi.1RCKvg6vuaFdtReQgtuUmNhyVF3RIor/EOHznAuL5n2xiQMoU4L9L6ZOA2YdGkyx20eAhw',1,NULL),(8,'Sophie','Taylor','sophie.taylor@example.com','$pbkdf2-sha512$25000$YIyx1hrDOGdsbc3ZW2sNwQ$cczW1ORhVYsqEr.UyrscaBqJcB8rUWksJGnVcbv.WT9qerMd5S5YAAcXFR4LRhxq7Ly5B.OM8wP3VH7MECZVxQ',1,NULL),(9,'Mia','Thomas','mia.thomas@example.com','$pbkdf2-sha512$25000$wrgXAqD0HqNUqnVOybk3xg$s3oW5RLmxPov3.EoDjOyf0MBSUwHrnNaNPItnU7uIXTvveksdWIXiMy5iMDYTC4urpjWf/USGFuubRiIwaTbow',1,NULL),(10,'Jacob','Roberts','jacob.roberts@example.com','$pbkdf2-sha512$25000$lnKulZKSEgKg9F7LuVeqtQ$neELTTwKF0eNr7PIa3o2cDtqmsKrMw9C7ERGHP77FXes3YjwTa.41nB/NTOtXXXFK/aP3CdDgAVCZl9rQkeFJQ',1,NULL),(11,'Thomas','Khan','thomas.khan@example.com','$pbkdf2-sha512$25000$E8I4x7gXohRiLEWIMWbsHQ$kuIpZ9Y1EaWNHFMxpfYhkkXRjGvGeyZeJaYhASCkcRf1mGuMouUZxUemm5FW7hmjeZZFg7vTYrVBhlLwp5Mwlw',1,NULL),(12,'Emily','Lewis','emily.lewis@example.com','$pbkdf2-sha512$25000$NSbkvPe.dy6lFILQeo/xHg$z5L1QvrTjASsYoBUCX58p9DELQij73JzbjZzyxMD3kZmKB/lUSvwQIh.X/UGoiKQhpCWPYIqWdj6jjXpek8nlQ',1,NULL),(13,'Lily','Jackson','lily.jackson@example.com','$pbkdf2-sha512$25000$8V6LkZKSEsK4d26tlTKGkA$L2YEqLxR8TlHBuHs8Rn2xR29OVhqrz6F9Ur4b0tuLnMKyvyR9oVLyVZQh0NMymhTGP32sF/1tET4f4ISjoK.3g',1,NULL),(14,'Ava','Clarke','ava.clarke@example.com','$pbkdf2-sha512$25000$SanVmnPuvXcuhfDeG8MYYw$ZU2GA1X77HSP2JeX2D.VKASFdXFhlkDTqjJNGnXYCiBMUMN.QWSNfMY6R7Cpe9bjmUAmqNgARaV5on2XdHBs4w',1,NULL),(15,'Isla','James','isla.james@example.com','$pbkdf2-sha512$25000$m/Me41wLwfhf610rZWytlQ$yfa84sHNXiOA7wPy9miSYkvX4.Gg.du3ragZ4YBSxpQ0szMPp2l2nVL.1smGoKmwpp.fzl5/71SrZhlcrlAUIQ',1,NULL),(16,'Alfie','Phillips','alfie.phillips@example.com','$pbkdf2-sha512$25000$EQKAUKrVWovx3rv3vjdm7A$9giHNttRjP2Hocasw9RlSqPvIkve/gDv76R/.wYMqTSYLNdvZeaUHmMOBqCMtYMhiZTrAqJCXwPjCzJeAUXwZA',1,NULL),(17,'Olivia','Wilson','olivia.wilson@example.com','$pbkdf2-sha512$25000$EEKIESJE6F1rbU2J8X5PKQ$npIjO7FTOmyif0D.IhyFp8bG57B2V2oorIXqyO9eDPQ20bNlJ.5NKUHcC/W2PefeGpWTv0rajEYsBOoL2hvrRw',1,NULL),(18,'Jessica','Ali','jessica.ali@example.com','$pbkdf2-sha512$25000$6P2f0zpH6B1DqFWqFUKIsQ$Ss3Ee4M35v3WTll2fsq2GGT87VRWAxxinvrNs5Ik1rSYS4AxesNp5yKSuNzkzGTVl9DaXHak.KHJcG1gOYLB1Q',1,NULL),(19,'Riley','Mason','riley.mason@example.com','$pbkdf2-sha512$25000$l7KW8n5PSSklRAgBoNTaew$O9uayLS7PtMnOlX2ypuvfnlRXB5pIXBoj8Gs9SKk3en7MGryyqkcp8ecHATUJO8.zk8bPkXsbwRof2n/puGZAQ',1,NULL),(20,'William','Mitchell','william.mitchell@example.com','$pbkdf2-sha512$25000$OGcMgTAmhFDKubd2jnGOUQ$z1yD76h8xoZE7ipMyfB56cmcqTSgnSS3vRm5Qn5zibmMXaSjyl2jAdlMNlbjWAAscYe0Ybd6CySf7PSafsEkdw',1,NULL),(21,'James','Rose','james.rose@example.com','$pbkdf2-sha512$25000$MeacM0aI8d6bs7YWwpgzpg$yu7RVHdiOWtPxueaoMBD084mPheaLxXEOSuISK6GPy6mtKKN3Ea.tZw9gwKapnegnA6372bS9P3wM8G9Z0btsQ',1,NULL),(22,'Geoffrey','Davis','geoffrey.davis@example.com','$pbkdf2-sha512$25000$iFFKiXHOOYcw5rzX.r93zg$YJp.NnFlXTqn9sJO2GUP7VWcEpEJ5v70PweZsLJ5aWoXl/L8kE3t8.A6gVx1HxYw3O7f2bbo3lx9bcwa5gP8Nw',1,NULL),(23,'Lisa','Davies','lisa.davies@example.com','$pbkdf2-sha512$25000$o9TamxPCmFPKufdeS8n5Hw$tdHi3DxoSXP/ySBkibMLvyCWDOAn8SM2lyZHfymzOpUbG.UIwfiW9AJPZR83jAAjduNXXA.T3U8M6aei4mxHng',1,NULL),(24,'Benjamin','Rodriguez','benjamin.rodriguez@example.com','$pbkdf2-sha512$25000$bI0xxhij9J4TIgTgHCOkdA$qCwR2zcH23YmrUmzUOFk0OeWgVEFi0aG5CzkmTRVSYUPEA3IzrIucRCR.AqVP7jdlYse.4wbKmrt7FvU8UD1jw',1,NULL),(25,'Stacey','Cox','stacey.cox@example.com','$pbkdf2-sha512$25000$yZmT8j4nJGRMKSWEUIpxrg$kmBSN4s.lkC7Vg8polTsR0syr.dR3JyOIPb0zopHqLx5znZDHs15PJrr8T/KZCkaZZXi/pCa2evjJaL2s4lgpw',1,NULL),(26,'Lucy','Alexander','lucy.alexander@example.com','$pbkdf2-sha512$25000$s9Yag5AyhnBuLQVgDMF47w$CYZiM.UmvZB6AzETfUC/yj7hF5fxAjz95y4P9svYucNLmkAScNI.2l/Ad9Z5Y/W7lBVwEpTSKCdWLjsmi0lpeg',1,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-06 15:55:52
