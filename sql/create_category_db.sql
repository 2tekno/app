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

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
