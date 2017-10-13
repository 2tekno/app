-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.17-log - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             9.4.0.5146
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.categoryproperty: ~6 rows (approximately)
DELETE FROM `categoryproperty`;
/*!40000 ALTER TABLE `categoryproperty` DISABLE KEYS */;
INSERT INTO `categoryproperty` (`CategoryPropertyID`, `CategoryID`, `PropertyID`, `PropertyValue`, `Sequence`, `Created`) VALUES
	(1, 14, 4, 'Honda', NULL, NULL),
	(2, 14, 7, '100K', NULL, NULL),
	(3, 14, 9, '2020rssarara', NULL, NULL),
	(4, 14, 1, 'Red', NULL, NULL),
	(6, 9, 10, 'mmmmmmmmmmm', NULL, NULL),
	(7, 9, 11, 'New', NULL, NULL);
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

-- Dumping data for table adappdata.karma: ~5 rows (approximately)
DELETE FROM `karma`;
/*!40000 ALTER TABLE `karma` DISABLE KEYS */;
INSERT INTO `karma` (`user_id`, `recipient_id`, `karma`) VALUES
	(1, 1, 1),
	(1, 2, 1),
	(2, 2, 2),
	(2, 3, 1),
	(1, 1, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.messages: ~17 rows (approximately)
DELETE FROM `messages`;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` (`MessageID`, `PostingID`, `SenderUserID`, `ReceiverUserID`, `ParentMessageID`, `MessageSubject`, `MessageText`, `DeletedByUser`, `Created`, `Deleted`) VALUES
	(1, 49, 23, NULL, NULL, 'subject zzz', 'message xxx\r\nslfwfnwe w;efmw;fmw;fw;f  wwef;mwe;fm\r\nw;fnwelfnwelf\r\nwf;wenfwnfwlnfw  wflwlnefwlnef', NULL, '2017-05-02 17:22:00', '0000-00-00 00:00:00'),
	(2, 49, 23, NULL, 0, 'sdcasda', 'asasdas alsfnalf  qwlfnqlfn  qlwfnqlnfqw\r\nqwf;mqwfnqw\r\n\r\nqfm;qf;qmnq;  qflnqlfqwnkgkgkgk  gkmgkgkgkg', NULL, '2017-05-02 17:39:25', '0000-00-00 00:00:00'),
	(3, 49, 23, NULL, 0, 'test 2', 'test 2 message here ....', NULL, '2017-05-01 16:56:50', '0000-00-00 00:00:00'),
	(4, 49, 23, NULL, 0, 'Nissan Sentra - is it avail?', 'hey, i\'m interested. sdfm;wfw\nweflwefwef  wefwef  wfwef  ewf wnfwlf\nfwefw\nwflwnfwl', NULL, '2017-05-02 17:39:29', '0000-00-00 00:00:00'),
	(5, 0, 23, NULL, 4, 'Re: ', 'swdwedw wdwdwdwd', NULL, '2017-05-02 20:05:37', '0000-00-00 00:00:00'),
	(6, 0, 23, NULL, 2, 'ascasc', 'ascaca', NULL, '2017-05-02 20:27:53', '0000-00-00 00:00:00'),
	(7, 0, 23, NULL, 1, 'Re:subject zzz', 'test May 24. kndndndndn', NULL, '2017-05-23 09:57:31', '0000-00-00 00:00:00'),
	(8, 0, 23, 23, 4, 'Re:Nissan Sentra - is it avail?', 'zdcsvsdvs', NULL, '2017-05-23 10:48:09', '0000-00-00 00:00:00'),
	(9, 52, 23, 23, 0, 're: image uploading fix', 'hhhhh?', NULL, '2017-05-24 11:31:54', '0000-00-00 00:00:00'),
	(10, 43, 18, 18, 0, 're: test 200', 'hhhh?', NULL, '2017-05-24 11:32:45', '0000-00-00 00:00:00'),
	(11, 52, 18, 18, 0, 're: image uploading fix', 'xxxx?', NULL, '2017-05-24 11:34:30', '0000-00-00 00:00:00'),
	(12, 52, 18, 23, 0, 'rr: image uploading fix', 'sdvffege', NULL, '2017-05-24 11:40:54', '0000-00-00 00:00:00'),
	(13, 0, 23, 18, 12, 'Re:rr: image uploading fix', 'sold already', NULL, '2017-05-24 11:41:35', '0000-00-00 00:00:00'),
	(14, 55, 18, 18, 0, 'jkfgjkfgjkgfjk', 'mfjfjkfjk', NULL, '2017-05-26 18:07:34', '0000-00-00 00:00:00'),
	(15, 0, 18, 18, 14, 'Re:jkfgjkfgjkgfjk', 'sgsdgsd', NULL, '2017-05-26 18:08:04', '0000-00-00 00:00:00'),
	(16, 0, 23, 18, 12, 'Re:rr: image uploading fix', 'July 10 message.', NULL, '2017-07-10 17:07:44', '0000-00-00 00:00:00'),
	(17, 52, 35, 23, 0, 'hey', 'hey xxxxx', NULL, '2017-10-04 15:43:39', '0000-00-00 00:00:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.posting: ~58 rows (approximately)
DELETE FROM `posting`;
/*!40000 ALTER TABLE `posting` DISABLE KEYS */;
INSERT INTO `posting` (`PostingID`, `UserID`, `CategoryID`, `PostingText`, `Title`, `Price`, `Active`, `DeletedByUser`, `Created`, `Edited`, `Expired`, `IpAddress`, `Location`, `Type`, `IsSold`, `Category`) VALUES
	(1, 18, 9, 'Description here', 'Title here', 123.00, NULL, NULL, '2016-05-12 16:52:50', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Buy Now', NULL, NULL),
	(2, 18, 14, '22222222222222', '222222222222222', 222.00, NULL, NULL, '2016-05-12 16:54:19', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(3, 18, 9, 'werewrw', 'werwrw', 333.00, NULL, NULL, '2016-05-12 16:57:21', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(4, 18, 9, 'xxxxxxxxxxxxxx', 'xxxxxxxxxxxxxxx', 11111.00, NULL, NULL, '2016-05-12 16:58:49', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(5, 18, 9, 'xxxxxxxxxx', 'xxxxxxxxxxx', 222.00, 0, NULL, '2016-05-12 17:18:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(6, 18, 9, 'Description hereegrerge', 'fgerg', 333.00, 0, NULL, '2016-05-12 17:21:10', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(7, 18, 9, 'Description here', 'Title here', 333.00, 0, NULL, '2016-05-12 17:24:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(8, 18, 9, 'Description here', 'Title here', 333.00, 0, NULL, '2016-05-12 17:34:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(10, 18, 9, 'Nissan Sentra for sale. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dignissim id erat lobortis commodo. Ut malesuada quis arcu non imperdiet. Proin accumsan, tellus quis euismod pulvinar, nisi nisi luctus felis, vitae suscipit eros lacus eget tellus. Donec quis urna odio. Fusce laoreet odio vitae enim blandit, eu lacinia est ultrices. Maecenas ut est at velit gravida commodo. Nunc vestibulum tristique magna ut scelerisque', 'Nissan Sentra for sale.', 333.00, 0, NULL, '2016-05-12 17:38:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(11, 18, 9, 'aaaaaaaaaa', 'aaaaaa', 333.00, 0, NULL, '2016-05-12 17:40:49', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(12, 18, 9, 'efwefw', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 17:45:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(13, 18, 9, 'BMW 325 for sale. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dignissim id erat lobortis commodo. Ut malesuada quis arcu non imperdiet. Proin accumsan, tellus quis euismod pulvinar, nisi nisi luctus felis, vitae suscipit eros lacus eget tellus. Donec quis urna odio. Fusce laoreet odio vitae enim blandit, eu lacinia est ultrices. Maecenas ut est at velit gravida commodo. Nunc vestibulum tristique magna ut scelerisque', 'BMW for sale.', 8.00, 0, NULL, '2016-05-12 17:49:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(14, 18, 9, 'efwefw', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 17:52:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(15, 18, 9, 'Nissan Altima for sale. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dignissim id erat lobortis commodo. Ut malesuada quis arcu non imperdiet. Proin accumsan, tellus quis euismod pulvinar, nisi nisi luctus felis, vitae suscipit eros lacus eget tellus. Donec quis urna odio. Fusce laoreet odio vitae enim blandit, eu lacinia est ultrices. Maecenas ut est at velit gravida commodo. Nunc vestibulum tristique magna ut scelerisque', 'Nissan Altima for sale.', 222.00, 0, NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(16, 18, 9, 'efwefw', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(17, 18, 9, 'efwefw', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(18, 18, 9, 'efwefw', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 18:20:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(19, 18, 9, 'TOYOTA CAMRY.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dignissim id erat lobortis commodo. Ut malesuada quis arcu non imperdiet. Proin accumsan, tellus quis euismod pulvinar, nisi nisi luctus felis, vitae suscipit eros lacus eget tellus. Donec quis urna odio. Fusce laoreet odio vitae enim blandit, eu lacinia est ultrices. Maecenas ut est at velit gravida commodo. Nunc vestibulum tristique magna ut scelerisque', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 18:21:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(20, 18, 9, 'efwefw', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 18:22:55', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(21, 18, 9, 'JEEP for sale. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dignissim id erat lobortis commodo. Ut malesuada quis arcu non imperdiet. Proin accumsan, tellus quis euismod pulvinar, nisi nisi luctus felis, vitae suscipit eros lacus eget tellus. Donec quis urna odio. Fusce laoreet odio vitae enim blandit, eu lacinia est ultrices. Maecenas ut est at velit gravida commodo. Nunc vestibulum tristique magna ut scelerisque', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 18:24:39', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(22, 18, 9, 'efwefw', 'sdfwdfw', 222.00, 0, NULL, '2016-05-12 18:27:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(24, 18, 14, 'Description here', 'Title here', 1234.00, 0, NULL, '2016-05-12 18:31:11', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(25, 18, 14, 'Description heretyjtyj', 'Title herevb gntyt', 70000.00, 0, NULL, '2016-05-12 23:10:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(26, 18, 9, 'Description here', 'Title here', 5555.00, 0, NULL, '2016-05-12 23:43:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(27, 18, 19, 'Description here', 'Title here', 111.00, 0, NULL, '2016-05-13 00:22:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(28, 18, 0, 'Description here', 'Title here 7171', 71717.00, 0, NULL, '2016-05-25 12:17:02', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(29, 18, 0, '7777777777777', '7777777777777', 777.00, 0, NULL, '2016-05-25 12:18:13', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(30, 18, 0, 'Description here', 'Title here', 555.00, 0, NULL, '2016-05-25 12:49:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(31, 18, 9, 'Description here', 'Title here', 555.00, 0, NULL, '2016-05-25 12:50:28', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(32, 18, 4, 'antique title Description here', 'antique title', 500000.00, 0, NULL, '2016-05-25 22:22:15', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(33, 18, 25, 'Lenses & Filters xxxxxxxxxxxxx', 'Lenses & Filters  777', 777.00, 0, NULL, '2016-05-25 23:28:16', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(34, 18, 12, 'Description House 4000 sq.f.', 'House', 700000.00, 0, NULL, '2016-05-26 13:57:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(35, 18, 14, 'Descri32de3de3ption here', 'TEST AUTO', 300.00, 0, NULL, '2016-06-15 20:41:12', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(36, 18, 3, 'zzz', 'zzz', 333.00, 0, NULL, '2016-10-07 18:25:26', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(37, 18, 0, 'ergergergerger', 'test 1', 500.00, 0, NULL, '2016-11-07 16:15:54', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(38, 18, 0, 'dfbdfhdfgher', 'test 2', 700.00, 0, NULL, '2016-11-07 16:17:10', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(39, 18, 0, 'ccccccccccccc', 'test # 3', 600.00, 0, NULL, '2016-11-07 16:17:58', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(40, 18, 0, 'erteeertete', 'test # 4', 250.00, 0, NULL, '2016-11-07 18:42:58', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(41, 18, 0, 'ergegeg', 'test 100', 450.00, 0, NULL, '2016-11-08 18:03:09', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(42, 18, 0, 'rhrtrhrth', 'test 100', 450.00, 0, NULL, '2016-11-08 18:04:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(43, 18, 0, 'TOYOTA CAMRY.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dignissim id erat lobortis commodo. Ut malesuada quis arcu non imperdiet. Proin accumsan, tellus quis euismod pulvinar, nisi nisi luctus felis, vitae suscipit eros lacus eget tellus. Donec quis urna odio. Fusce laoreet odio vitae enim blandit, eu lacinia est ultrices. Maecenas ut est at velit gravida commodo. Nunc vestibulum tristique magna ut scelerisque', 'test 200', 555.00, 0, NULL, '2016-11-08 18:05:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(44, 18, 0, 'xxx', 'xxx', 700.00, 0, NULL, '2017-02-13 17:30:01', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(45, 23, 0, 'sdwewedwe', 'wedwefwefwef', 0.00, 0, NULL, '2017-03-13 20:53:01', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(46, 23, 0, 'test 2', 'test 2', 550.00, 0, NULL, '2017-03-13 22:42:59', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(47, 23, 0, 'xxx', 'xxx', 222.00, 0, NULL, '2017-03-13 22:48:32', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(48, 23, 0, 'sss', 'sss', 222.00, 0, NULL, '2017-03-13 22:49:53', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(49, 23, 0, 'asddqd qwdqwdq', 'test 3', 1345.00, 0, NULL, '2017-03-19 16:11:28', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(50, 23, 0, 'sdqw qwdqwdqwd', 'test 5', 222.00, 0, NULL, '2017-03-19 16:20:19', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(51, 18, 0, 'new img test', 'new img test', 400.00, 0, NULL, '2017-05-04 20:09:14', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(52, 23, 0, 'image uploading fix', 'image uploading fix', 555.00, 0, NULL, '2017-05-05 18:35:39', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(53, 23, 0, ' zzz', 'zzz', 345.00, 0, NULL, '2017-05-18 12:14:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(54, 18, 0, ' Accessories', 'Accessories', 500.00, 0, NULL, '2017-05-25 08:14:40', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', NULL, NULL),
	(55, 18, 0, ' Leather case. Color - orange.', 'Leather case', 50.00, 0, NULL, '2017-05-25 08:19:05', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', 0, NULL),
	(56, 18, 0, ' sss', 'sss', 222.00, 0, NULL, '2017-05-25 09:34:36', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', 0, NULL),
	(57, 18, 0, ' buy now test', 'buy now test', 333.00, 0, NULL, '2017-05-25 09:51:21', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', 0, NULL),
	(58, 18, 0, ' sfas', 'zsdaf', 500.00, 0, NULL, '2017-05-26 18:10:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, 'Buy Now', 0, NULL),
	(59, 35, 0, ' test #1																																																																																																																																																																																				', 'test #1 - title X2', 575.00, 0, NULL, '2017-10-02 15:16:37', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Maple Ridge', 'Make an Offer', 1, 'Auto,Electronics,Shoes,Tools,Etc.'),
	(60, 35, 0, ' new ZZZ																																																																																																																																																																																																																																																																																																																		', 'new ZZZ', 115.00, 0, NULL, '2017-10-04 14:33:35', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Pitt Meadows', 'Buy Now', 0, 'Auto,Shoes,Tools'),
	(61, 35, NULL, ' TV SONY', 'TV SONY', 500.00, 1, NULL, '2017-10-06 10:47:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 'Burnaby', 'Bid It', 0, 'Electronics');
/*!40000 ALTER TABLE `posting` ENABLE KEYS */;

-- Dumping structure for table adappdata.postingimage
DROP TABLE IF EXISTS `postingimage`;
CREATE TABLE IF NOT EXISTS `postingimage` (
  `ImageID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PostingID` bigint(20) DEFAULT '0',
  `FileName` varchar(1000) DEFAULT NULL,
  `IsDeleted` smallint(6) DEFAULT '0',
  PRIMARY KEY (`ImageID`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.postingimage: ~58 rows (approximately)
DELETE FROM `postingimage`;
/*!40000 ALTER TABLE `postingimage` DISABLE KEYS */;
INSERT INTO `postingimage` (`ImageID`, `PostingID`, `FileName`, `IsDeleted`) VALUES
	(1, 10, 'nissan3.png', 0),
	(2, 15, 'nissan3.png', 0),
	(3, 38, 'nissan3.png', 0),
	(4, 13, 'nissan3.png', 0),
	(5, 39, 'nissan3.png', 0),
	(6, 39, 'nissan3.png', 0),
	(7, 40, 'nissan3.png', 0),
	(8, 21, 'nissan3.png', 0),
	(9, 42, 'nissan3.png', 0),
	(10, 42, 'nissan3.png', 0),
	(11, 43, 'nissan3.png', 0),
	(12, 43, 'nissan3.png', 0),
	(13, 44, '1487035801773.png', 0),
	(14, 44, '1487035801775.png', 0),
	(15, 44, '1487035801776.png', 0),
	(16, 44, '1487035801776.png', 0),
	(17, 45, '1489463581388.png', 0),
	(18, 45, '1489463581388.png', 0),
	(19, 46, '1489470179455.png', 0),
	(20, 47, '1489470512717.png', 0),
	(21, 48, '1489470593779.png', 0),
	(22, 49, '1489965088229.png', 0),
	(23, 49, '1489965088231.png', 0),
	(24, 49, '1489965088231.png', 0),
	(25, 50, '1489965619499.png', 0),
	(26, 50, '1489965619500.png', 0),
	(27, 51, '1493953754974.png', 0),
	(28, 51, '1493953754974.png', 0),
	(29, 51, '1493953754974.png', 0),
	(30, 51, '1493953754974.png', 0),
	(31, 52, '1494034539841.png', 0),
	(32, 52, '1494034539843.png', 0),
	(33, 52, '1494034539845.png', 0),
	(34, 53, '1495134892127.png', 0),
	(35, 53, '1495134892131.png', 0),
	(36, 54, '1495725280357.png', 0),
	(37, 54, '1495725280357.png', 0),
	(38, 55, '1495725545100.png', 0),
	(39, 56, '1495730076533.png', 0),
	(40, 57, '1495731081850.png', 0),
	(41, 58, '1495847446770.png', 0),
	(42, 58, '1495847446774.png', 0),
	(43, 58, '1495847446776.png', 0),
	(44, 59, '1506982597666.png', 1),
	(45, 59, '1507150563254.png', 0),
	(46, 59, '1507151233720.png', 1),
	(47, 59, '1507151338416.png', 1),
	(48, 59, '1507152054305.png', 1),
	(49, 59, '1507152420953.png', 1),
	(50, 59, '1507152581470.png', 1),
	(51, 60, '1507152815041.png', 0),
	(52, 60, '1507152815042.png', 1),
	(53, 59, '1507247534897.png', 0),
	(54, 59, '1507247534900.png', 0),
	(55, 59, '1507247534901.png', 0),
	(56, 60, '1507305557067.png', 0),
	(57, 60, '1507305557071.png', 0),
	(58, 60, '1507307770249.png', 0),
	(59, 61, '1507312023285.png', 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.postingproperty: ~26 rows (approximately)
DELETE FROM `postingproperty`;
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

-- Dumping structure for table adappdata.property
DROP TABLE IF EXISTS `property`;
CREATE TABLE IF NOT EXISTS `property` (
  `PropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PropertyDescription` varchar(200) DEFAULT NULL,
  `PropertyDescriptionFull` varchar(1000) DEFAULT NULL,
  `PropertyDataTypeID` int(11) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.property: ~8 rows (approximately)
DELETE FROM `property`;
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

-- Dumping structure for table adappdata.propertydatatype
DROP TABLE IF EXISTS `propertydatatype`;
CREATE TABLE IF NOT EXISTS `propertydatatype` (
  `PropertyDataTypeID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PropertyDataTypeDescription` varchar(200) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PropertyDataTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.propertydatatype: ~3 rows (approximately)
DELETE FROM `propertydatatype`;
/*!40000 ALTER TABLE `propertydatatype` DISABLE KEYS */;
INSERT INTO `propertydatatype` (`PropertyDataTypeID`, `PropertyDataTypeDescription`, `Created`) VALUES
	(1, 'Text', NULL),
	(2, 'Number', NULL),
	(3, 'List', NULL);
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
  `IpAddress` varchar(50) DEFAULT '',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

-- Dumping data for table adappdata.users: ~3 rows (approximately)
DELETE FROM `users`;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`UserID`, `UserName`, `AccountType`, `FirstName`, `LastName`, `Email`, `Password`, `Active`, `Created`, `Modified`, `Salt`, `IpAddress`) VALUES
	(23, 'tplokhotniouk@gmail.com', '', '', '', 'tplokhotniouk@gmail.com', '$2a$10$tmWcJLiURWsGKiPjLItkcOw5NjlcY3AZO.74lwMV3jisKOeXBUlCa', b'1', '2017-03-13 17:35:31', NULL, '', ''),
	(26, 'eplokhotniouk@gmail.com', '', '', '', 'eplokhotniouk@gmail.com', '', b'1', '2017-07-05 16:30:01', NULL, '', ''),
	(27, 'admin@mrpmanager.com', '', '', '', 'admin@mrpmanager.com', '', b'1', '2017-07-05 16:30:48', NULL, '', ''),
	(35, '2tekno@gmail.com', '', '', '', '2tekno@gmail.com', '', b'1', '2017-07-10 17:50:23', NULL, '', '');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
