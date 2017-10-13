-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.10-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.3.0.5124
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for tekno_node
CREATE DATABASE IF NOT EXISTS `adappdata` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `adappdata`;

-- Dumping structure for table tekno_node.category
CREATE TABLE IF NOT EXISTS `category` (
  `CategoryID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ParentCategoryID` bigint(20) DEFAULT '0',
  `CategoryDescription` varchar(200) DEFAULT NULL,
  `CategoryDescriptionFull` varchar(1000) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.category: ~41 rows (approximately)
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

-- Dumping structure for table tekno_node.categoryproperty
CREATE TABLE IF NOT EXISTS `categoryproperty` (
  `CategoryPropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CategoryID` bigint(20) NOT NULL,
  `PropertyID` bigint(20) NOT NULL,
  `PropertyValue` varchar(200) DEFAULT NULL,
  `Sequence` tinytext,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryPropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.categoryproperty: ~6 rows (approximately)
/*!40000 ALTER TABLE `categoryproperty` DISABLE KEYS */;
INSERT INTO `categoryproperty` (`CategoryPropertyID`, `CategoryID`, `PropertyID`, `PropertyValue`, `Sequence`, `Created`) VALUES
	(1, 14, 4, 'Honda', NULL, NULL),
	(2, 14, 7, '100K', NULL, NULL),
	(3, 14, 9, '2020rssarara', NULL, NULL),
	(4, 14, 1, 'Red', NULL, NULL),
	(6, 9, 10, 'mmmmmmmmmmm', NULL, NULL),
	(7, 9, 11, 'New', NULL, NULL);
/*!40000 ALTER TABLE `categoryproperty` ENABLE KEYS */;

-- Dumping structure for function tekno_node.GetTree
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

-- Dumping structure for table tekno_node.karma
CREATE TABLE IF NOT EXISTS `karma` (
  `user_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `karma` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.karma: ~4 rows (approximately)
/*!40000 ALTER TABLE `karma` DISABLE KEYS */;
INSERT INTO `karma` (`user_id`, `recipient_id`, `karma`) VALUES
	(1, 1, 1),
	(1, 2, 1),
	(2, 2, 2),
	(2, 3, 1),
	(1, 1, 1);
/*!40000 ALTER TABLE `karma` ENABLE KEYS */;

-- Dumping structure for table tekno_node.posting
CREATE TABLE IF NOT EXISTS `posting` (
  `PostingID` bigint(20) NOT NULL AUTO_INCREMENT,
  `UserID` bigint(20) NOT NULL,
  `CategoryID` bigint(20) NOT NULL,
  `PostingText` varchar(1000) NOT NULL,
  `Title` varchar(1000) NOT NULL,
  `Price` decimal(14,2) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `DeletedByUser` bit(1) DEFAULT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Edited` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `Expired` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `IpAddress` varchar(50) DEFAULT NULL,
  `Location` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`PostingID`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.posting: ~39 rows (approximately)
/*!40000 ALTER TABLE `posting` DISABLE KEYS */;
INSERT INTO `posting` (`PostingID`, `UserID`, `CategoryID`, `PostingText`, `Title`, `Price`, `Active`, `DeletedByUser`, `Created`, `Edited`, `Expired`, `IpAddress`, `Location`) VALUES
	(1, 18, 9, 'Description here', 'Title here', 123.00, NULL, NULL, '2016-05-12 16:52:50', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(2, 18, 14, '22222222222222', '222222222222222', 222.00, NULL, NULL, '2016-05-12 16:54:19', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(3, 18, 9, 'werewrw', 'werwrw', 333.00, NULL, NULL, '2016-05-12 16:57:21', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(4, 18, 9, 'xxxxxxxxxxxxxx', 'xxxxxxxxxxxxxxx', 11111.00, NULL, NULL, '2016-05-12 16:58:49', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(5, 18, 9, 'xxxxxxxxxx', 'xxxxxxxxxxx', 222.00, b'0', NULL, '2016-05-12 17:18:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(6, 18, 9, 'Description hereegrerge', 'fgerg', 333.00, b'0', NULL, '2016-05-12 17:21:10', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(7, 18, 9, 'Description here', 'Title here', 333.00, b'0', NULL, '2016-05-12 17:24:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(8, 18, 9, 'Description here', 'Title here', 333.00, b'0', NULL, '2016-05-12 17:34:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(10, 18, 9, 'aaaaaaaaaa', 'aaaaaa', 333.00, b'0', NULL, '2016-05-12 17:38:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(11, 18, 9, 'aaaaaaaaaa', 'aaaaaa', 333.00, b'0', NULL, '2016-05-12 17:40:49', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(12, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 17:45:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(13, 18, 9, 'efwefw', 'sdfwdfw', 8.00, b'0', NULL, '2016-05-12 17:49:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(14, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 17:52:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(15, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(16, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(17, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(18, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:20:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(19, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:21:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(20, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:22:55', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(21, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:24:39', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(22, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:27:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(24, 18, 14, 'Description here', 'Title here', 1234.00, b'0', NULL, '2016-05-12 18:31:11', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(25, 18, 14, 'Description heretyjtyj', 'Title herevb gntyt', 70000.00, b'0', NULL, '2016-05-12 23:10:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(26, 18, 9, 'Description here', 'Title here', 5555.00, b'0', NULL, '2016-05-12 23:43:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(27, 18, 19, 'Description here', 'Title here', 111.00, b'0', NULL, '2016-05-13 00:22:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(28, 18, 0, 'Description here', 'Title here 7171', 71717.00, b'0', NULL, '2016-05-25 12:17:02', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(29, 18, 0, '7777777777777', '7777777777777', 777.00, b'0', NULL, '2016-05-25 12:18:13', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(30, 18, 0, 'Description here', 'Title here', 555.00, b'0', NULL, '2016-05-25 12:49:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(31, 18, 9, 'Description here', 'Title here', 555.00, b'0', NULL, '2016-05-25 12:50:28', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(32, 18, 4, 'antique title Description here', 'antique title', 500000.00, b'0', NULL, '2016-05-25 22:22:15', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(33, 18, 25, 'Lenses & Filters xxxxxxxxxxxxx', 'Lenses & Filters  777', 777.00, b'0', NULL, '2016-05-25 23:28:16', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(34, 18, 12, 'Description House 4000 sq.f.', 'House', 700000.00, b'0', NULL, '2016-05-26 13:57:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(35, 18, 14, 'Descri32de3de3ption here', 'TEST AUTO', 300.00, b'0', NULL, '2016-06-15 20:41:12', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(36, 18, 3, 'zzz', 'zzz', 333.00, b'0', NULL, '2016-10-07 18:25:26', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(37, 18, 0, 'ergergergerger', 'test 1', 500.00, b'0', NULL, '2016-11-07 16:15:54', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(38, 18, 0, 'dfbdfhdfgher', 'test 2', 700.00, b'0', NULL, '2016-11-07 16:17:10', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(39, 18, 0, 'ccccccccccccc', 'test # 3', 600.00, b'0', NULL, '2016-11-07 16:17:58', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(40, 18, 0, 'erteeertete', 'test # 4', 250.00, b'0', NULL, '2016-11-07 18:42:58', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(41, 18, 0, 'ergegeg', 'test 100', 450.00, b'0', NULL, '2016-11-08 18:03:09', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(42, 18, 0, 'rhrtrhrth', 'test 100', 450.00, b'0', NULL, '2016-11-08 18:04:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL),
	(43, 18, 0, 'ergregerge', 'test 200', 555.00, b'0', NULL, '2016-11-08 18:05:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL);
/*!40000 ALTER TABLE `posting` ENABLE KEYS */;

-- Dumping structure for table tekno_node.postingimage
CREATE TABLE IF NOT EXISTS `postingimage` (
  `ImageID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PostingID` bigint(20) DEFAULT '0',
  `FileName` varchar(1000) DEFAULT NULL,
  `IsDeleted` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ImageID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.postingimage: ~11 rows (approximately)
/*!40000 ALTER TABLE `postingimage` DISABLE KEYS */;
INSERT INTO `postingimage` (`ImageID`, `PostingID`, `FileName`, `IsDeleted`) VALUES
	(1, 38, '1478564230116.png', b'0'),
	(2, 38, '1478564230119.png', b'0'),
	(3, 38, '1478564230119.png', b'0'),
	(4, 38, '1478564230119.png', b'0'),
	(5, 39, '1478564278117.png', b'0'),
	(6, 39, '1478564278118.png', b'0'),
	(7, 40, '1478572978978.png', b'0'),
	(8, 40, '1478572978981.png', b'0'),
	(9, 42, '1478657065833.png', b'0'),
	(10, 42, '1478657065835.png', b'0'),
	(11, 43, '1478657122995.png', b'0'),
	(12, 43, '1478657122998.png', b'0');
/*!40000 ALTER TABLE `postingimage` ENABLE KEYS */;

-- Dumping structure for table tekno_node.postingproperty
CREATE TABLE IF NOT EXISTS `postingproperty` (
  `PostingPropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PostingID` bigint(20) NOT NULL,
  `PropertyID` bigint(20) NOT NULL,
  `PropertyValue` varchar(200) DEFAULT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PostingPropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.postingproperty: ~26 rows (approximately)
/*!40000 ALTER TABLE `postingproperty` DISABLE KEYS */;
INSERT INTO `postingproperty` (`PostingPropertyID`, `PostingID`, `PropertyID`, `PropertyValue`, `Created`) VALUES
	(1, 23, 10, 'weqdqwdq', '2016-05-12 18:28:59'),
	(2, 23, 11, 'used', '2016-05-12 18:28:59'),
	(3, 24, 4, 'fddgfdg', '2016-05-12 18:31:11'),
	(4, 24, 7, 'dfgdg', '2016-05-12 18:31:11'),
	(5, 24, 9, '2012', '2016-05-12 18:31:11'),
	(6, 24, 1, 'dfgd', '2016-05-12 18:31:11'),
	(7, 25, 4, 'Honda', '2016-05-12 23:10:52'),
	(8, 25, 7, '100K', '2016-05-12 23:10:52'),
	(9, 25, 9, '2020rssarara', '2016-05-12 23:10:52'),
	(10, 25, 1, 'Red', '2016-05-12 23:10:52'),
	(11, 26, 10, 'mmmmmmmmmmm', '2016-05-12 23:43:07'),
	(12, 26, 11, 'New', '2016-05-12 23:43:07'),
	(13, 28, 1, 'Red', '2016-05-25 12:17:02'),
	(14, 28, 4, 'Honda', '2016-05-25 12:17:02'),
	(15, 28, 7, '100K', '2016-05-25 12:17:02'),
	(16, 28, 9, '2020rssarara', '2016-05-25 12:17:02'),
	(17, 29, 10, '7777777777', '2016-05-25 12:18:13'),
	(18, 29, 11, '77777777777', '2016-05-25 12:18:13'),
	(19, 30, 10, 'mmmmmmmmmmm', '2016-05-25 12:49:07'),
	(20, 30, 11, 'New', '2016-05-25 12:49:07'),
	(21, 31, 10, 'mmmmmmmmmmm', '2016-05-25 12:50:29'),
	(22, 31, 11, 'New', '2016-05-25 12:50:29'),
	(23, 35, 1, 'Red', '2016-06-15 20:41:12'),
	(24, 35, 4, 'Honda', '2016-06-15 20:41:12'),
	(25, 35, 7, '100K', '2016-06-15 20:41:12'),
	(26, 35, 9, '2020rssarara', '2016-06-15 20:41:12');
/*!40000 ALTER TABLE `postingproperty` ENABLE KEYS */;

-- Dumping structure for table tekno_node.property
CREATE TABLE IF NOT EXISTS `property` (
  `PropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PropertyDescription` varchar(200) DEFAULT NULL,
  `PropertyDescriptionFull` varchar(1000) DEFAULT NULL,
  `PropertyDataTypeID` int(11) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.property: ~8 rows (approximately)
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
INSERT INTO `property` (`PropertyID`, `PropertyDescription`, `PropertyDescriptionFull`, `PropertyDataTypeID`, `Created`) VALUES
	(1, 'Color', 'Color', 3, NULL),
	(3, 'Size', 'Size', 1, NULL),
	(4, 'Make', 'Make', 3, NULL),
	(7, 'Mileage', 'Mileage', 1, NULL),
	(8, 'Model', 'Model', 1, NULL),
	(9, 'Year', 'Year', 2, NULL),
	(10, 'Author', 'Author', 1, NULL),
	(11, 'Condition', 'Condition', 1, NULL);
/*!40000 ALTER TABLE `property` ENABLE KEYS */;

-- Dumping structure for table tekno_node.propertydatatype
CREATE TABLE IF NOT EXISTS `propertydatatype` (
  `PropertyDataTypeID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PropertyDataTypeDescription` varchar(200) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PropertyDataTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.propertydatatype: ~3 rows (approximately)
/*!40000 ALTER TABLE `propertydatatype` DISABLE KEYS */;
INSERT INTO `propertydatatype` (`PropertyDataTypeID`, `PropertyDataTypeDescription`, `Created`) VALUES
	(1, 'Text', NULL),
	(2, 'Number', NULL),
	(3, 'List', NULL);
/*!40000 ALTER TABLE `propertydatatype` ENABLE KEYS */;

-- Dumping structure for table tekno_node.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(255) COLLATE utf8_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text COLLATE utf8_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table tekno_node.sessions: ~0 rows (approximately)
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;

-- Dumping structure for table tekno_node.users
CREATE TABLE IF NOT EXISTS `users` (
  `UserID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserName` varchar(30) DEFAULT '',
  `FirstName` varchar(30) DEFAULT '',
  `LastName` varchar(30) DEFAULT '',
  `Email` varchar(70) DEFAULT '',
  `Password` varchar(60) NOT NULL DEFAULT '',
  `Active` bit(1) NOT NULL DEFAULT b'1',
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Modified` timestamp NULL DEFAULT NULL,
  `Salt` varchar(50) NOT NULL DEFAULT '',
  `IpAddress` varchar(50) DEFAULT '',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.users: ~0 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`UserID`, `UserName`, `FirstName`, `LastName`, `Email`, `Password`, `Active`, `Created`, `Modified`, `Salt`, `IpAddress`) VALUES
	(18, '2tekno@gmail.com', '', '', '', '$2a$10$X6LBQHrrboFQ7KQwCHayTuGffzBp/eqeh49n2X2jSkIhgBtiz1QeO', b'1', '0000-00-00 00:00:00', '2016-04-20 22:08:10', '', '');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
