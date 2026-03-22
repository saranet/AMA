-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 26, 2025 at 12:21 AM
-- Server version: 8.0.31
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `attenda`
--

-- --------------------------------------------------------

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
CREATE TABLE IF NOT EXISTS `schedules` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `time_in` time NOT NULL,
  `time_out` time NOT NULL,
  `wrokingDays` json NOT NULL,
  `created_by` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `schedules_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `schedules`
--

INSERT INTO `schedules` (`id`, `slug`, `time_in`, `time_out`, `wrokingDays`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'morn', '09:43:00', '19:43:00', '[1, 2, 3]', '', '2025-07-26 09:53:22', '2024-12-05 20:13:21'),
(3, 'evening', '16:33:49', '23:31:40', '[1, 2, 3]', '', '2025-08-05 11:34:18', NULL),
(7, 'fff', '07:00:00', '15:00:00', '[\"MONDAY\", \"TUESDAY\", \"WEDNESDAY\", \"THURSDAY\", \"FRIDAY\", \"SATURDAY\", \"SUNDAY\"]', '2', '2025-08-22 15:24:45', NULL),
(8, 'test', '07:00:00', '15:00:00', '[\"MONDAY\", \"TUESDAY\", \"WEDNESDAY\"]', '2', '2025-08-22 15:33:12', NULL),
(9, 'tre', '19:51:00', '19:51:00', '[\"MONDAY\", \"TUESDAY\", \"WEDNESDAY\", \"THURSDAY\", \"FRIDAY\", \"SATURDAY\", \"SUNDAY\"]', '2', '2025-08-22 15:51:52', NULL),
(10, 'dd', '01:33:00', '13:33:00', '[\"MONDAY\", \"TUESDAY\", \"WEDNESDAY\", \"THURSDAY\", \"SUNDAY\"]', '136', '2025-08-22 21:40:17', NULL),
(11, 'ffffffs', '02:58:00', '07:58:00', '[\"MONDAY\", \"TUESDAY\", \"WEDNESDAY\", \"THURSDAY\", \"FRIDAY\", \"SATURDAY\", \"SUNDAY\"]', '137', '2025-08-22 22:58:47', NULL),
(12, 'r', '03:08:00', '15:08:00', '[\"MONDAY\", \"TUESDAY\", \"WEDNESDAY\", \"THURSDAY\", \"FRIDAY\", \"SATURDAY\", \"SUNDAY\"]', '138', '2025-08-22 23:08:31', NULL),
(15, 'rrrr', '03:08:00', '15:08:00', '[\"MONDAY\", \"TUESDAY\", \"WEDNESDAY\", \"THURSDAY\", \"FRIDAY\", \"SATURDAY\", \"SUNDAY\"]', '144', '2025-08-22 23:15:23', NULL);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
