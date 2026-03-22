-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 25, 2025 at 01:27 PM
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
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `position` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `pin_code` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `permissions` text COLLATE utf8mb3_unicode_ci,
  `CompanyName` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'Deef Factory',
  `EmployeApproved` tinyint(1) NOT NULL DEFAULT '0',
  `RejectedReason` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Branch_id` int NOT NULL,
  `wrokingDays` json NOT NULL,
  `totalLeaveBalance` int NOT NULL,
  `totalLeaveApproved` int NOT NULL,
  `totalLeavePending` int NOT NULL,
  `totalLeaveCancelled` int NOT NULL,
  `Leave_id` int UNSIGNED DEFAULT NULL,
  `FirstTimeLogin` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employees_email_unique` (`email`),
  KEY `leave_fk` (`Leave_id`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `name`, `position`, `email`, `pin_code`, `permissions`, `CompanyName`, `EmployeApproved`, `RejectedReason`, `email_verified_at`, `remember_token`, `Branch_id`, `wrokingDays`, `totalLeaveBalance`, `totalLeaveApproved`, `totalLeavePending`, `totalLeaveCancelled`, `Leave_id`, `FirstTimeLogin`, `created_at`, `updated_at`) VALUES
(2, 'sara', 'Admin', 'sror@a.com', '$2y$10$Q7yhrdOoj/gaU617FIJOxeikbWvFGlgXrS20kXTmpHQoSiQ64wOja', '1', 'Deef Factory', 1, NULL, NULL, NULL, 1, '[1, 2, 3]', 0, 3, 3, 2, NULL, '2025-08-12 15:27:55', '2025-08-12 11:27:55', NULL),
(118, 'zeze', 'Emp', 'z@x.com', '$2y$10$Q7yhrdOoj/gaU617FIJOxeikbWvFGlgXrS20kXTmpHQoSiQ64wOja', '1', 'Deef Factory', 1, NULL, NULL, NULL, 1, 'null', 0, 0, 0, 1, NULL, '2025-08-16 08:38:19', '2025-08-16 08:40:51', NULL),
(122, 'mian', 'Employee', 'm@m.com', '$2y$10$qDqPdMDnmZHcGdvkIsBv4.Pu00Ah5/JtOFzRTiQT.NA6Inj1JfwEG', '1', 'Deef Factory', 0, NULL, NULL, 'cd12467f69773645aa0013aaecef417e', 0, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-21 09:10:37', NULL),
(123, 'Nitish Gupta', 'ADMIN', 'sror', '$2y$10$Kp34kyF7W7tJdJvLBeISZ.V2cOcqhlAIhiaaPjhUcLti.sy7Ye9ta', '1', 'Deef Factory', 0, NULL, NULL, '9434b409f8180a56e1f7dd89223fe4a1', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:05:28', NULL),
(124, 'ss', 'Employee', 's@av.com', '$2y$10$CzwtuV52RuL.XaiRy1ktJewxRpoB38YIK/KGqttYgzEB8GyL6w1PW', '1', 'Deef Factory', 0, NULL, NULL, 'd2f52e26b01f082c89d4ec9bde1f84d1', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:17:00', NULL),
(125, 'ss', 'Employee', 'sq@av.com', '$2y$10$LCuPE2cxYGvDh3rQmTCaW.Bm1aMBGaOeP4aRHTu0rudv.SxK.ApWO', '1', 'Deef Factory', 0, NULL, NULL, '509d8e075c8b564592b42bc59fbdcc53', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:26:35', NULL),
(126, 'ss', 'Employee', 'sqw@av.com', '$2y$10$wRXak4/CRJDWRZw9/2ange/1BcVT.CDOGmkO7mJ8yOL/XyXNFTj2u', '1', 'Deef Factory', 0, NULL, NULL, '235392d372643e191ac5e845bbc71b7b', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:27:25', NULL),
(127, 'Nitish Gupta', 'Employee', 'sror12', '$2y$10$JWW9bUapnnHVkYQ4KVQCtek2YB0NbrvGMW7MfgSU.kdoX8mhFECQC', '1', 'Deef Factory', 0, NULL, NULL, 'fc343973fe4a066527278b434b6d6449', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:29:08', NULL),
(128, 'ss', 'Employee', 'sqwq@av.com', '$2y$10$cGRElrhUiaq9LQu.X0iBQu7wNP2xscLyjD2Xk/UxDTw52P5iCXyIa', '1', 'Deef Factory', 0, NULL, NULL, '97dd0c13d3094c398d4f705f089727d5', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:30:01', NULL),
(129, 'ss', 'Employee', 'sqwqd@av.com', '$2y$10$1bWctheYfRlEsct8rbVyGew2KKyGi6M2TnMQIX8Yzy7.X5IQHDw2.', '1', 'Deef Factory', 0, NULL, NULL, '81b86b6a4291e607ca0c8fa23f31ccaa', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:31:50', NULL),
(130, 'e', 'Employee', 'ee', '$2y$10$9tgRxHZpDyRxfHWr3TLIdO9vo3bz0KThCv4pAMsmTGWghwusO2wqm', '1', 'Deef Factory', 0, NULL, NULL, '892310b77b7cd1b5d21d1836d670263a', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:35:41', NULL),
(131, 'e', 'Employee', 'eee', '$2y$10$MxvWbqhLw1gJYVHbRJjiju0KeASxeNhjaFMYvGYtRLukOcPkupyXC', '1', 'Deef Factory', 0, NULL, NULL, 'facb67e4781260ea4276a4f9f4cda0f8', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:39:20', NULL),
(132, 'e', 'Employee', 'eeed', '$2y$10$Xd0fz6Pcovv2k1rDoEBrCu2o28b1Zowym5lhxJO.204fE2zvfj7UK', '1', 'Deef Factory', 0, NULL, NULL, 'ef4c02d1650c531221628b7f08c85bd0', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:42:36', NULL),
(133, 'e', 'Employee', 'eeedf', '$2y$10$8vkAZa/bsjrDNEhkcofaLO/azrrHgdW4hL93DxFjW5BcOeS2Lwmre', '1', 'Deef Factory', 0, NULL, NULL, '3c6c5f063e57fc167c3b10957e4e8963', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:43:03', NULL),
(134, 'qqq', 'Employee', 'wqw', '$2y$10$0zmXsrvBnYwLAmjLnByUouMbJUpAfOTOKGcnjb5BZ9z2kI7Pn2JLm', '1', 'Deef Factory', 0, NULL, NULL, 'be0b2e42ba139c3ec9275cb83475dabb', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 19:53:25', NULL),
(135, 'ewq', 'Employee', 'qquu', '$2y$10$hw273wt0DlPgS.4y5reiiONXIDyOrT5ABUf7s/DnLgC5mLTw5Halq', '1', 'Deef Factory', 0, NULL, NULL, '9304e00764ef66cf12fa9b36e9a27263', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 21:13:34', NULL),
(136, 'dd', 'Admin', 'dd', '$2y$10$GTl4c.4w1BHEjsNMoqNAI.nvJNJFbZJe7J2pvy/pX50zBkQJqh1Q2', '1', 'Deef Factory', 0, NULL, NULL, '9281c20d82182c939ce82b4d69582695', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 21:40:16', NULL),
(137, 'rrr', 'Admin', 'rrr', '$2y$10$hRATI.U7mmWbxhse2bkFmubMiPAC1wEPgBks96U.woPuf0H0chwjm', '1', 'Deef Factory', 0, NULL, NULL, '7f4a187fe53a5b505f8ad5350faf2e7f', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 22:58:47', NULL),
(138, 'y', 'Admin', 'y', '$2y$10$zIRU0Flo7UxEGRH9E4jJeO2aLeZzFQ5/rX4jQQ5P40Jsi2UcCnzyy', '1', 'Deef Factory', 0, NULL, NULL, '02d9f6c7410646ca0be242ccd8213a91', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 23:08:31', NULL),
(141, 'yr', 'Admin', 'yr', '$2y$10$NqJkj557GQxHbvoy2wVoM.gBJhdzNte6ZbYkDxgOkUmmqVnA4axC2', '1', 'Deef Factory', 0, NULL, NULL, '787d8c1362782dfccd361a056cb7658e', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 23:13:13', NULL),
(143, 'yre', 'Admin', 'yre', '$2y$10$K/xXHSETZaMLTsa/th7tJOboi049Ty/raFdcJq8/WKijYJCEmv.gy', '1', 'Deef Factory', 0, NULL, NULL, '536ae4dbe64922e702f4957ec3fea72b', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 23:13:45', NULL),
(144, 'yret', 'Admin', 'yrett', '$2y$10$BTUrlbiG3V2hrjskpXNhru4dy8/lDIHi2FibH0zPh7ZfZ5DNmyExG', '1', 'Deef Factory', 0, NULL, NULL, '8aae0a3bb324538d59a8af1b85621db1', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-22 23:15:23', NULL),
(145, 'hh', 'Employee', 'hh', '$2y$10$f3YqdS95KI56ma/a9mA1x.DinldMe97iRzXIT2NZuZVHBq5UMkPbm', '1', 'Deef Factory', 0, NULL, NULL, 'a626e07a5da5c51d9814a5135e0bb47d', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-23 08:50:44', NULL),
(146, 'uu', 'Employee', 'uu', '$2y$10$z9L2oyIAbXA3tJzF7v5cMuWqa/LjQHLyR5Ri8Wv/jWy0MxFBSgN1q', '1', 'Deef Factory', 0, NULL, NULL, '615379233a148540bfb08e4c6098e274', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-23 13:25:56', NULL),
(147, 'hg', 'Employee', 'hg', '$2y$10$MniXrsURI/nIbqJW7H74YeTCZ/82XzQo1W5xdGdDHR4jDF.xn6P.a', '1', 'Deef Factory', 0, NULL, NULL, 'f43ba44abcfe9b7c8246a621b0a1b22b', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-23 13:59:26', NULL),
(148, 'Nitish Gupta', 'Employee', 'sror1233', '$2y$10$T2pOiMgQMFAmyw/3WSuQSu909eJISQ4wJp8HJvZ3N1xNiegKEyZQS', '1', 'Deef Factory', 0, NULL, NULL, 'b26e2d1cbdb723c5e7b76597487145ff', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-24 21:28:40', NULL),
(149, 'Nitish Gupta', 'Employee', 'sror12333', '$2y$10$q0uEH.aTG7sOTzKp19MJf.jGDrpxxQLRcJpknSC.rpDWnAG01dpii', '1', 'Deef Factory', 0, NULL, NULL, 'f87b334de3c9d49a5ab2257eb466cbd7', 1, 'null', 0, 0, 0, 0, NULL, '0000-00-00 00:00:00', '2025-08-24 21:32:11', NULL);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `leave_fk` FOREIGN KEY (`Leave_id`) REFERENCES `leaves` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
