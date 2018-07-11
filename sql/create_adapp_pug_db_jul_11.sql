-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.22-0ubuntu0.16.04.1 - (Ubuntu)
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for adappdata
DROP DATABASE IF EXISTS `adappdata`;
CREATE DATABASE IF NOT EXISTS `adappdata` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `adappdata`;

-- Dumping structure for table adappdata.category
DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `CategoryID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ParentCategoryID` bigint(20) DEFAULT '0',
  `CategoryDescription` varchar(200) DEFAULT NULL,
  `CategoryDescriptionFull` varchar(1000) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.category: ~42 rows (approximately)
DELETE FROM `category`;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` (`CategoryID`, `ParentCategoryID`, `CategoryDescription`, `CategoryDescriptionFull`, `Created`) VALUES
	(1, 0, 'Antique', 'Antique', NULL),
	(2, 0, 'Art', 'Art', NULL),
	(3, 1, 'Architectural & Garden', 'Architectural & Garden', NULL),
	(4, 1, 'Asian Antiques', 'Asian Antiques', NULL),
	(5, 1, 'Books & Manuscripts', 'Books & Manuscripts', NULL),
	(6, 1, 'Decorative Arts', 'Decorative Arts', NULL),
	(7, 2, 'Direct from the Artist', 'Direct from the Artist', NULL),
	(8, 2, 'Art from Dealers & Resellers', 'Art from Dealers & Resellers', NULL),
	(9, 5, 'Books', 'Books', NULL),
	(10, 0, 'Business & Industrial', 'Business & Industrial', NULL),
	(11, 10, 'Agriculture & Forestry', 'Agriculture & Forestry', NULL),
	(12, 0, 'Construction', 'Construction', NULL),
	(13, 10, 'Electrical & Test Equipment', 'Electrical & Test Equipment', NULL),
	(14, 0, 'Automotive', 'Automotive', NULL),
	(15, 2, 'Wholesale Lots', 'Wholesale Lots', NULL),
	(16, 0, 'Cameras & Photo', 'Cameras & Photo', NULL),
	(17, 16, 'Binoculars & Telescopes', 'Binoculars & Telescopes', NULL),
	(18, 16, 'Camera Drones', 'Camera Drones', NULL),
	(19, 16, 'Camcorders', 'Camcorders', NULL),
	(20, 16, 'Digital Cameras', 'Digital Cameras', NULL),
	(21, 16, 'Camera & Photo Accessories', 'Camera & Photo Accessories', NULL),
	(22, 16, 'Digital Photo Frames', 'Digital Photo Frames', NULL),
	(23, 0, 'Film Photography', 'Film Photography', NULL),
	(24, 16, 'Flashes & Flash Accessories', 'Flashes & Flash Accessories', NULL),
	(25, 16, 'Lenses & Filters', 'Lenses & Filters', NULL),
	(26, 0, 'Cell Phones & Accessories', 'Cell Phones & Accessories', NULL),
	(27, 0, 'Jobs', 'Jobs', NULL),
	(28, 27, 'Accounting/Finance', 'Accounting/Finance', NULL),
	(29, 27, 'Office Administration', 'Office Administration', NULL),
	(30, 27, 'Customer Service', 'Customer Service', NULL),
	(31, 27, 'Computer', 'Computer', NULL),
	(32, 27, 'Education', 'Education', NULL),
	(33, 27, 'Medical/Health', 'Medical/Health', NULL),
	(34, 27, 'Management/Professional', 'Management/Professional', NULL),
	(35, 0, 'Buy/Sell', 'Buy/Sell', NULL),
	(36, 14, 'Auto Parts', 'Auto Parts', NULL),
	(37, 14, 'Service', 'Service', NULL),
	(38, 0, 'Rentals', 'Rentals', NULL),
	(39, 38, 'House/Condo', 'House/Condo', NULL),
	(40, 38, 'Commercial', 'Commercial', NULL),
	(41, 38, 'Vacation', 'Vacation', NULL),
	(42, 38, 'Wanted', 'Wanted', NULL);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;

-- Dumping structure for table adappdata.categoryproperty
DROP TABLE IF EXISTS `categoryproperty`;
CREATE TABLE IF NOT EXISTS `categoryproperty` (
  `CategoryPropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CategoryID` bigint(20) NOT NULL,
  `PropertyID` bigint(20) NOT NULL,
  `PropertyValue` varchar(200) DEFAULT NULL,
  `Sequence` tinytext,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryPropertyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.categoryproperty: ~0 rows (approximately)
DELETE FROM `categoryproperty`;
/*!40000 ALTER TABLE `categoryproperty` DISABLE KEYS */;
/*!40000 ALTER TABLE `categoryproperty` ENABLE KEYS */;

-- Dumping structure for function adappdata.GetTree
DROP FUNCTION IF EXISTS `GetTree`;
DELIMITER //
CREATE DEFINER=`tekno_admin`@`%.%.%.%` FUNCTION `GetTree`(`GivenCategoryID` int(64)) RETURNS varchar(1024) CHARSET utf8 COLLATE utf8_unicode_ci
    DETERMINISTIC
BEGIN

    DECLARE rv,q,queue,queue_children,queue_names VARCHAR(1024);
    DECLARE queue_length,pos INT;
    DECLARE GivenSSN,front_ssn VARCHAR(64);

    SET rv = '';

    SELECT ParentCategoryID INTO GivenSSN
    FROM category
    WHERE CategoryID = GivenCategoryID;
    #AND Designation <> 'OWNER';
    IF ISNULL(GivenSSN) THEN
        RETURN ev;
    END IF;

    SET queue = GivenSSN;
    SET queue_length = 1;

    WHILE queue_length > 0 DO
        IF queue_length = 1 THEN
            SET front_ssn = queue;
            SET queue = '';
        ELSE
            SET pos = LOCATE(',',queue);
            SET front_ssn = LEFT(queue,pos - 1);
            SET q = SUBSTR(queue,pos + 1);
            SET queue = q;
        END IF;
        SET queue_length = queue_length - 1;
        SELECT IFNULL(qc,'') INTO queue_children
        FROM
        (
            SELECT GROUP_CONCAT(CategoryID) qc FROM category
            WHERE CategoryID = front_ssn #AND Designation <> 'OWNER'
        ) A;
        SELECT IFNULL(qc,'') INTO queue_names
        FROM
        (
            SELECT GROUP_CONCAT(CategoryDescription) qc FROM category
            WHERE CategoryID = front_ssn #AND Designation <> 'OWNER'
        ) A;
        IF LENGTH(queue_children) = 0 THEN
            IF LENGTH(queue) = 0 THEN
                SET queue_length = 0;
            END IF;
        ELSE
            IF LENGTH(rv) = 0 THEN
                SET rv = queue_names;
            ELSE
                SET rv = CONCAT(rv,',',queue_names);
            END IF;
            IF LENGTH(queue) = 0 THEN
                SET queue = queue_children;
            ELSE
                SET queue = CONCAT(queue,',',queue_children);
            END IF;
            SET queue_length = LENGTH(queue) - LENGTH(REPLACE(queue,',','')) + 1;
        END IF;
    END WHILE;

    RETURN rv;

END//
DELIMITER ;

-- Dumping structure for table adappdata.karma
DROP TABLE IF EXISTS `karma`;
CREATE TABLE IF NOT EXISTS `karma` (
  `user_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `karma` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.karma: ~0 rows (approximately)
DELETE FROM `karma`;
/*!40000 ALTER TABLE `karma` DISABLE KEYS */;
/*!40000 ALTER TABLE `karma` ENABLE KEYS */;

-- Dumping structure for table adappdata.messages
DROP TABLE IF EXISTS `messages`;
CREATE TABLE IF NOT EXISTS `messages` (
  `MessageID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PostingID` bigint(20) NOT NULL,
  `SenderUserID` bigint(20) NOT NULL,
  `ReceiverUserID` bigint(20) DEFAULT NULL,
  `ParentMessageID` bigint(20) DEFAULT NULL,
  `MessageSubject` varchar(1000) DEFAULT NULL,
  `MessageText` varchar(1000) DEFAULT NULL,
  `DeletedByUser` smallint(6) DEFAULT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Deleted` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`MessageID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.messages: ~3 rows (approximately)
DELETE FROM `messages`;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` (`MessageID`, `PostingID`, `SenderUserID`, `ReceiverUserID`, `ParentMessageID`, `MessageSubject`, `MessageText`, `DeletedByUser`, `Created`, `Deleted`) VALUES
	(1, 1, 1, 2, 0, 'skdkwdfw', 'wdlwineflwefn', NULL, '2017-10-25 01:13:31', '0000-00-00 00:00:00'),
	(2, 14, 2, 1, 0, 'vfergge', 'erfegferg', NULL, '2018-02-10 06:41:59', '0000-00-00 00:00:00'),
	(3, 0, 2, 1, 1, 'Re:skdkwdfw', 'sdvefvevrv', NULL, '2018-02-10 06:42:26', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;

-- Dumping structure for table adappdata.posting
DROP TABLE IF EXISTS `posting`;
CREATE TABLE IF NOT EXISTS `posting` (
  `PostingID` bigint(20) NOT NULL AUTO_INCREMENT,
  `UserID` bigint(20) NOT NULL,
  `CategoryID` bigint(20) DEFAULT NULL,
  `PostingText` varchar(1000) NOT NULL,
  `Title` varchar(1000) NOT NULL,
  `Price` decimal(14,2) DEFAULT NULL,
  `Active` smallint(6) DEFAULT NULL,
  `DeletedByUser` smallint(6) DEFAULT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Edited` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `Expired` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `IpAddress` varchar(50) DEFAULT NULL,
  `Location` varchar(1000) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  `IsSold` smallint(6) DEFAULT NULL,
  `Category` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`PostingID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.posting: ~14 rows (approximately)
DELETE FROM `posting`;
/*!40000 ALTER TABLE `posting` DISABLE KEYS */;
INSERT INTO `posting` (`PostingID`, `UserID`, `CategoryID`, `PostingText`, `Title`, `Price`, `Active`, `DeletedByUser`, `Created`, `Edited`, `Expired`, `IpAddress`, `Location`, `Type`, `IsSold`, `Category`) VALUES
	(1, 3, NULL, ' test																								', 'test', 777.00, 1, NULL, '2017-11-16 23:08:13', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Burnaby', 'For free', 0, 'Electronics,Shoes,Tools'),
	(2, 1, NULL, ' New with tags Boys shirt size 7', 'Boys shirt new size 7', 10.00, 1, NULL, '2017-11-28 20:55:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Coquitlam', 'Buy Now', 0, 'Etc.'),
	(3, 1, NULL, ' Lightly used Fitbit charge ', 'Free Fitbit Charge', 0.00, 1, NULL, '2017-11-28 21:00:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Coquitlam', 'For free', 0, 'Electronics'),
	(4, 1, NULL, 'Baby Sleepers new with tags', 'Baby Sleepers', 10.00, 1, NULL, '2017-11-28 21:06:48', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'Make an Offer', 0, 'Etc.'),
	(5, 2, NULL, 'Test 2: flip flops																																													', 'Test 2: flip flops', 555.00, 1, NULL, '2017-12-02 23:49:40', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'For free', 0, 'Electronics,Shoes,Tools'),
	(6, 2, NULL, 'Logic book 																														', 'Book', 1000.00, 1, NULL, '2017-12-03 06:39:01', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'For free', 0, 'Etc.'),
	(7, 4, NULL, ' jhjkghhjgghj			jhkjh									', 'super shoe', 100.00, 1, NULL, '2017-12-04 02:32:09', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'Buy Now', 0, 'Shoes'),
	(8, 1, NULL, '42 inch tv', 'sharp tv', 800.00, 1, NULL, '2017-12-05 05:56:37', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'Bid It', 0, 'Electronics'),
	(9, 1, NULL, ' nike shoes', 'nike', 100.00, 1, NULL, '2017-12-05 05:57:40', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'Buy Now', 0, 'Shoes'),
	(10, 1, NULL, ' free kids clothes ', 'free clothes', 0.00, 1, NULL, '2017-12-05 05:59:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Coquitlam', 'For free', 0, 'Etc.'),
	(11, 1, NULL, 'womens jackets', 'jackets', 100.00, 1, NULL, '2017-12-05 06:00:59', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'Make an Offer', 0, 'Etc.'),
	(12, 1, NULL, ' iphone for sale', 'iphone', 300.00, 1, NULL, '2017-12-05 06:01:51', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'North Vancouver', 'Bid It', 0, 'Electronics'),
	(13, 1, NULL, ' kids jeans', 'jeans for sale', 20.00, 1, NULL, '2017-12-05 06:03:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Maple Ridge', 'Buy Now', 0, 'Etc.'),
	(14, 1, NULL, ' wiiiw						', 'hsywiw', 600.00, 1, NULL, '2017-12-05 06:28:39', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Surrey', 'Bid It', 0, 'Etc.'),
	(15, 2, NULL, ' test ergege																																																', 'test 11111', 333.00, 1, NULL, '2018-02-08 04:30:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'North Vancouver', 'For free', 0, 'Other'),
	(16, 6, NULL, 'chair				', 'chair', 77.00, 1, NULL, '2018-05-01 05:09:10', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'Buy Now', 0, 'Architectural & Garden,Art from Dealers & Resellers,Lenses & Filters'),
	(17, 6, NULL, 'nnnn	nn', 'nn', 222.00, 1, NULL, '2018-05-03 06:01:34', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Vancouver', 'For free', 0, 'Asian Antiques,Auto Parts,Automotive,Camera & Photo Accessories');
/*!40000 ALTER TABLE `posting` ENABLE KEYS */;

-- Dumping structure for table adappdata.postingclicks
DROP TABLE IF EXISTS `postingclicks`;
CREATE TABLE IF NOT EXISTS `postingclicks` (
  `PostingClickID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserCreatedID` int(11) unsigned DEFAULT NULL,
  `PostingID` int(11) unsigned NOT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PostingClickID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.postingclicks: ~0 rows (approximately)
DELETE FROM `postingclicks`;
/*!40000 ALTER TABLE `postingclicks` DISABLE KEYS */;
/*!40000 ALTER TABLE `postingclicks` ENABLE KEYS */;

-- Dumping structure for table adappdata.postingimage
DROP TABLE IF EXISTS `postingimage`;
CREATE TABLE IF NOT EXISTS `postingimage` (
  `ImageID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PostingID` bigint(20) DEFAULT '0',
  `FileName` varchar(1000) DEFAULT NULL,
  `IsDeleted` smallint(6) DEFAULT '0',
  `Angle` tinytext,
  PRIMARY KEY (`ImageID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.postingimage: ~16 rows (approximately)
DELETE FROM `postingimage`;
/*!40000 ALTER TABLE `postingimage` DISABLE KEYS */;
INSERT INTO `postingimage` (`ImageID`, `PostingID`, `FileName`, `IsDeleted`, `Angle`) VALUES
	(1, 1, '1510873693844.png', 0, '0'),
	(2, 2, '1511902552786.png', 0, '90'),
	(3, 3, '1511902823524.png', 0, '90'),
	(4, 4, '1511903208204.png', 0, '90'),
	(5, 5, '1512258580814.png', 0, '180'),
	(6, 5, '1512280619263.png', 0, '180'),
	(7, 6, '1512283141385.png', 0, '90'),
	(8, 7, '1512354729788.png', 0, NULL),
	(9, 8, '1512453397138.png', 0, NULL),
	(10, 9, '1512453460665.png', 0, NULL),
	(11, 10, '1512453586364.png', 0, NULL),
	(12, 10, '1512453586366.png', 0, NULL),
	(13, 11, '1512453659280.png', 0, NULL),
	(14, 12, '1512453711462.png', 0, NULL),
	(15, 13, '1512453803321.png', 0, NULL),
	(16, 14, '1512455319337.png', 0, '180'),
	(17, 6, '1518063320904.png', 0, '0'),
	(18, 15, '1518064207498.png', 0, '0'),
	(19, 15, '1518244074784.png', 0, '270'),
	(20, 16, '1525151350629.png', 0, '90'),
	(21, 17, '1525327294522.png', 0, '0');
/*!40000 ALTER TABLE `postingimage` ENABLE KEYS */;

-- Dumping structure for table adappdata.postingproperty
DROP TABLE IF EXISTS `postingproperty`;
CREATE TABLE IF NOT EXISTS `postingproperty` (
  `PostingPropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PostingID` bigint(20) NOT NULL,
  `PropertyID` bigint(20) NOT NULL,
  `PropertyValue` varchar(200) DEFAULT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PostingPropertyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.postingproperty: ~0 rows (approximately)
DELETE FROM `postingproperty`;
/*!40000 ALTER TABLE `postingproperty` DISABLE KEYS */;
/*!40000 ALTER TABLE `postingproperty` ENABLE KEYS */;

-- Dumping structure for table adappdata.property
DROP TABLE IF EXISTS `property`;
CREATE TABLE IF NOT EXISTS `property` (
  `PropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PropertyDescription` varchar(200) DEFAULT NULL,
  `PropertyDescriptionFull` varchar(1000) DEFAULT NULL,
  `PropertyDataTypeID` int(11) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PropertyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.property: ~0 rows (approximately)
DELETE FROM `property`;
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
/*!40000 ALTER TABLE `property` ENABLE KEYS */;

-- Dumping structure for table adappdata.propertydatatype
DROP TABLE IF EXISTS `propertydatatype`;
CREATE TABLE IF NOT EXISTS `propertydatatype` (
  `PropertyDataTypeID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PropertyDataTypeDescription` varchar(200) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PropertyDataTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.propertydatatype: ~0 rows (approximately)
DELETE FROM `propertydatatype`;
/*!40000 ALTER TABLE `propertydatatype` DISABLE KEYS */;
/*!40000 ALTER TABLE `propertydatatype` ENABLE KEYS */;

-- Dumping structure for table adappdata.sessions
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(255) COLLATE utf8_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text COLLATE utf8_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table adappdata.sessions: ~0 rows (approximately)
DELETE FROM `sessions`;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;

-- Dumping structure for table adappdata.userrating
DROP TABLE IF EXISTS `userrating`;
CREATE TABLE IF NOT EXISTS `userrating` (
  `UserRatingID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserCreatedID` int(11) unsigned NOT NULL,
  `UserReceivedID` int(11) unsigned NOT NULL,
  `Comment` varchar(200) DEFAULT NULL,
  `Rating` smallint(6) DEFAULT NULL,
  `PostingID` int(11) unsigned NOT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserRatingID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.userrating: ~0 rows (approximately)
DELETE FROM `userrating`;
/*!40000 ALTER TABLE `userrating` DISABLE KEYS */;
/*!40000 ALTER TABLE `userrating` ENABLE KEYS */;

-- Dumping structure for table adappdata.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `UserID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserName` varchar(30) DEFAULT '',
  `AccountType` varchar(30) DEFAULT '',
  `FirstName` varchar(30) DEFAULT '',
  `LastName` varchar(30) DEFAULT '',
  `Email` varchar(70) NOT NULL DEFAULT '',
  `Password` varchar(60) DEFAULT '',
  `Active` bit(1) DEFAULT b'1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Modified` timestamp NULL DEFAULT NULL,
  `Salt` varchar(50) DEFAULT '',
  `IpAddress` varchar(100) DEFAULT '',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.users: ~2 rows (approximately)
DELETE FROM `users`;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`UserID`, `UserName`, `AccountType`, `FirstName`, `LastName`, `Email`, `Password`, `Active`, `Created`, `Modified`, `Salt`, `IpAddress`) VALUES
	(1, '_nickelface504@gmail.com', '', '', '', '_nickelface504@gmail.com', '', b'1', '2017-11-16 22:48:47', NULL, '', '::ffff:127.0.0.1'),
	(2, '2tekno@gmail.com', '', '', '', '2tekno@gmail.com', '', b'1', '2017-11-16 23:07:10', NULL, '', '::ffff:127.0.0.1'),
	(3, 'tplokhotniouk@gmail.com', '', '', '', 'tplokhotniouk@gmail.com', '', b'1', '2017-11-17 23:44:06', NULL, '', '::ffff:127.0.0.1'),
	(4, 'ilia@funtik.com', '', '', '', 'ilia@funtik.com', '', b'1', '2017-12-04 02:30:38', NULL, '', '::ffff:127.0.0.1'),
	(5, 'pval08@gmail.com', '', '', '', 'pval08@gmail.com', '', b'1', '2018-02-14 02:19:10', NULL, '', '::ffff:127.0.0.1'),
	(6, 'zzz', '', '', '', 'zzz', '$2a$10$EmhISLHl5HQa3RJPVCHTKuNf.uI7DKvpVddD8NiJ9rgu8f9dzSVty', b'1', '2018-04-24 21:24:11', NULL, '', '0');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
