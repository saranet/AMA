
-- Database: `attenda`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendances`
--

DROP TABLE IF EXISTS `attendances`;
CREATE TABLE IF NOT EXISTS `attendances` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int UNSIGNED NOT NULL DEFAULT '0',
  `emp_id` int UNSIGNED NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `attendance_time` time NOT NULL DEFAULT '20:33:45',
  `attendance_date` date NOT NULL DEFAULT '2024-12-05',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `type` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attendances_emp_id_foreign` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attendances1`
--

DROP TABLE IF EXISTS `attendances1`;
CREATE TABLE IF NOT EXISTS `attendances1` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int UNSIGNED NOT NULL DEFAULT '0',
  `emp_id` int UNSIGNED NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `attendance_time` time NOT NULL DEFAULT '20:33:45',
  `attendance_date` date NOT NULL DEFAULT '2024-12-05',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `type` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
CREATE TABLE IF NOT EXISTS `branches` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Latitude` double NOT NULL,
  `Longitude` double NOT NULL,
  `Distance` double NOT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `company_id` bigint NOT NULL,
  `status_id` bigint NOT NULL DEFAULT '1' COMMENT '1=active,4=inactive',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `branches`
--

INSERT INTO `branches` (`id`, `name`, `address`, `Latitude`, `Longitude`, `Distance`, `phone`, `email`, `user_id`, `company_id`, `status_id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Head Office', 'Texas, USA', 0, 0, 0, '01234567890', 'admin@gmail.com', 1, 1, 1, NULL, '2024-07-29 05:48:12', '2024-07-29 05:48:12');

-- --------------------------------------------------------

--
-- Table structure for table `checks`
--

DROP TABLE IF EXISTS `checks`;
CREATE TABLE IF NOT EXISTS `checks` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` int UNSIGNED NOT NULL,
  `attendance_time` datetime NOT NULL,
  `leave_time` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `checks_emp_id_foreign` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
CREATE TABLE IF NOT EXISTS `companies` (
  `id` bigint UNSIGNED NOT NULL,
  `country_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_employee` int DEFAULT NULL,
  `business_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trade_licence_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subdomain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trade_licence_id` bigint UNSIGNED DEFAULT NULL,
  `status_id` bigint UNSIGNED NOT NULL DEFAULT '1',
  `is_main_company` enum('yes','no') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'no',
  `is_subscription` tinyint DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `country_id`, `name`, `company_name`, `email`, `phone`, `total_employee`, `business_type`, `trade_licence_number`, `subdomain`, `trade_licence_id`, `status_id`, `is_main_company`, `is_subscription`, `created_at`, `updated_at`) VALUES
(1, 223, 'Admin', 'Main Company', 'demo@onesttech.com', '+8801959335555', 100, 'Service', NULL, NULL, NULL, 1, 'yes', 0, '2024-07-29 05:48:12', '2024-07-29 05:48:12');

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

-- --------------------------------------------------------

--
-- Table structure for table `emp_activity`
--

DROP TABLE IF EXISTS `emp_activity`;
CREATE TABLE IF NOT EXISTS `emp_activity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `Branch_id` int NOT NULL,
  `breakInTimes` json DEFAULT NULL,
  `breakOutTimes` json DEFAULT NULL,
  `inTime` time DEFAULT NULL,
  `outTime` time DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 ;

--
-- Dumping data for table `emp_activity`
--



-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `finger_devices`
--

DROP TABLE IF EXISTS `finger_devices`;
CREATE TABLE IF NOT EXISTS `finger_devices` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `ip` varchar(45) COLLATE utf8mb3_unicode_ci NOT NULL,
  `serialNumber` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `finger_devices_serialnumber_unique` (`serialNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `finger_devices`
--

INSERT INTO `finger_devices` (`id`, `name`, `ip`, `serialNumber`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2, 'ssss', '192.168.1.235', '0278133900072\0', '2024-12-05 18:58:11', '2024-12-05 18:58:11', NULL),
(3, 'hh', '192.168.1.238', '0278133900063\0', '2024-12-05 19:13:32', '2024-12-05 19:13:32', NULL),
(5, 'test', '192.168.1.236', '0278134300011\0', '2024-12-08 22:52:32', '2024-12-08 22:52:32', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

DROP TABLE IF EXISTS `holidays`;
CREATE TABLE IF NOT EXISTS `holidays` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `attachment_id` bigint UNSIGNED DEFAULT NULL,
  `status_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `company_id` bigint UNSIGNED DEFAULT '1',
  `branch_id` bigint UNSIGNED DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `latetimes`
--

DROP TABLE IF EXISTS `latetimes`;
CREATE TABLE IF NOT EXISTS `latetimes` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` int UNSIGNED NOT NULL,
  `duration` time NOT NULL,
  `latetime_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `latetimes_emp_id_foreign` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leaves`
--

DROP TABLE IF EXISTS `leaves`;
CREATE TABLE IF NOT EXISTS `leaves` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int UNSIGNED NOT NULL DEFAULT '0',
  `emp_id` int UNSIGNED NOT NULL,
  `Branch_id` int UNSIGNED NOT NULL,
  `fromdate` date NOT NULL,
  `todate` date NOT NULL,
  `leaveReason` varchar(30) COLLATE utf8mb3_unicode_ci NOT NULL,
  `approvalTo` int NOT NULL,
  `rejectedReason` varchar(30) COLLATE utf8mb3_unicode_ci NOT NULL,
  `leave_time` time NOT NULL DEFAULT '20:33:52',
  `leave_date` date NOT NULL DEFAULT '2024-12-05',
  `status` enum('Approved','Cancelled','Pending','REJECTED') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'Pending',
  `SuspendReason` varchar(30) COLLATE utf8mb3_unicode_ci NOT NULL,
  `type` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `br_fk` (`Branch_id`),
  KEY `emp_id_foreign` (`emp_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `leaves`
--

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_11_25_113026_create_employees_table', 1),
(5, '2019_12_02_141403_create_roles_table', 1),
(6, '2019_12_03_044741_create_schedules_table', 1),
(7, '2019_12_03_045452_create_attendances_table', 1),
(8, '2019_12_03_045912_create_latetimes_table', 1),
(9, '2019_12_03_045930_create_overtimes_table', 1),
(10, '2019_12_03_050030_create_leaves_table', 1),
(11, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(12, '2019_12_22_183558_create_checks_table', 1),
(13, '2021_06_05_110414_create_finger_devices_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `overtimes`
--

DROP TABLE IF EXISTS `overtimes`;
CREATE TABLE IF NOT EXISTS `overtimes` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` int UNSIGNED NOT NULL,
  `duration` time NOT NULL,
  `overtime_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `overtimes_emp_id_foreign` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb3_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb3_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `permissions` text COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `slug`, `name`, `permissions`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'Adminstrator', NULL, '2024-12-05 17:38:29', '2024-12-05 17:38:29');

-- --------------------------------------------------------

--
-- Table structure for table `role_users`
--

DROP TABLE IF EXISTS `role_users`;
CREATE TABLE IF NOT EXISTS `role_users` (
  `user_id` int UNSIGNED NOT NULL,
  `role_id` int UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_users_role_id_foreign` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `role_users`
--

INSERT INTO `role_users` (`user_id`, `role_id`) VALUES
(41, 1);

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

-- --------------------------------------------------------

--
-- Table structure for table `schedule_employees`
--

DROP TABLE IF EXISTS `schedule_employees`;
CREATE TABLE IF NOT EXISTS `schedule_employees` (
  `emp_id` int UNSIGNED NOT NULL,
  `schedule_id` int UNSIGNED NOT NULL,
  `created_by` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `schedule_employees_emp_id_foreign` (`emp_id`),
  KEY `schedule_employees_schedule_id_foreign` (`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `schedule_employees`
--


-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `adminID` int NOT NULL,
  `pin_code` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `permissions` text COLLATE utf8mb3_unicode_ci,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `companyID` varchar(1) COLLATE utf8mb3_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `totalLeaveBalance` int NOT NULL,
  `totalLeaveApproved` int NOT NULL,
  `totalLeavePending` int NOT NULL,
  `totalLeaveCancelled` int NOT NULL,
  `companyName` varchar(30) COLLATE utf8mb3_unicode_ci NOT NULL,
  `wrokingDays` json NOT NULL,
  `inTime` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `outTime` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `employeeApproved` tinyint(1) NOT NULL,
  `rejectedReason` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `adminID`, `pin_code`, `permissions`, `email_verified_at`, `password`, `companyID`, `remember_token`, `created_at`, `updated_at`, `totalLeaveBalance`, `totalLeaveApproved`, `totalLeavePending`, `totalLeaveCancelled`, `companyName`, `wrokingDays`, `inTime`, `outTime`, `employeeApproved`, `rejectedReason`) VALUES
(41, 'Nitish Gupta', 'sror@a.com', 0, NULL, 'Employee', NULL, '$2y$10$Q7yhrdOoj/gaU617FIJOxeikbWvFGlgXrS20kXTmpHQoSiQ64wOja', '1', 'b16792966e3242d235726e75d9b5f5e4', NULL, NULL, 0, 0, 0, 0, '', '[1, 2, 3]', '09:00:00', '10:00:00', 1, ''),

-- Constraints for dumped tables
--

--
-- Constraints for table `attendances`
--
ALTER TABLE `attendances`
  ADD CONSTRAINT `attendances_emp_id_foreign` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `checks`
--
ALTER TABLE `checks`
  ADD CONSTRAINT `checks_emp_id_foreign` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `leave_fk` FOREIGN KEY (`Leave_id`) REFERENCES `leaves` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `latetimes`
--
ALTER TABLE `latetimes`
  ADD CONSTRAINT `latetimes_emp_id_foreign` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `leaves`
--
ALTER TABLE `leaves`
  ADD CONSTRAINT `br_fk` FOREIGN KEY (`Branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `leaves_emp_id_foreign` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `overtimes`
--
ALTER TABLE `overtimes`
  ADD CONSTRAINT `overtimes_emp_id_foreign` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_users`
--
ALTER TABLE `role_users`
  ADD CONSTRAINT `role_users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `schedule_employees`
--
ALTER TABLE `schedule_employees`
  ADD CONSTRAINT `schedule_employees_emp_id_foreign` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `schedule_employees_schedule_id_foreign` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
