-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1:3306
-- Thời gian đã tạo: Th10 08, 2026 lúc 06:28 PM
-- Phiên bản máy phục vụ: 8.3.0
-- Phiên bản PHP: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `lvtt`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `appointments`
--

DROP TABLE IF EXISTS `appointments`;
CREATE TABLE IF NOT EXISTS `appointments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_code` varchar(50) NOT NULL,
  `information_id` int NOT NULL,
  `slot_id` int NOT NULL,
  `reason` text,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `active_slot_id` int GENERATED ALWAYS AS ((case when (`status` in (_utf8mb4'cancelled',_utf8mb4'rejected')) then NULL else `slot_id` end)) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_appointments_booking_code` (`booking_code`),
  UNIQUE KEY `uq_appointments_active_slot` (`active_slot_id`),
  KEY `idx_appointments_information` (`information_id`),
  KEY `idx_appointments_slot` (`slot_id`),
  KEY `idx_appointments_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `doctor`
--

DROP TABLE IF EXISTS `doctor`;
CREATE TABLE IF NOT EXISTS `doctor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `specialty_id` int NOT NULL,
  `degree` varchar(255) DEFAULT NULL,
  `experience_years` int NOT NULL DEFAULT '0',
  `fee` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_doctor_user` (`user_id`),
  KEY `idx_doctor_specialty` (`specialty_id`)
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `information`
--

DROP TABLE IF EXISTS `information`;
CREATE TABLE IF NOT EXISTS `information` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `date` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_information_user` (`user_id`),
  KEY `idx_information_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `medical_records`
--

DROP TABLE IF EXISTS `medical_records`;
CREATE TABLE IF NOT EXISTS `medical_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int NOT NULL,
  `symptoms` text,
  `diagnosis` text,
  `prescription` text,
  `note` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_medical_records_appointment` (`appointment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE IF NOT EXISTS `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int NOT NULL,
  `order_code` varchar(100) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'VND',
  `payment_method` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `transaction_code` varchar(255) DEFAULT NULL,
  `payment_url` text,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_payments_order_code` (`order_code`),
  UNIQUE KEY `uq_payments_transaction_code` (`transaction_code`),
  KEY `idx_payments_appointment` (`appointment_id`),
  KEY `idx_payments_status` (`status`),
  KEY `idx_payments_method` (`payment_method`)
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `information_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `rating` int NOT NULL,
  `content` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_review_patient_doctor` (`information_id`,`doctor_id`),
  KEY `idx_reviews_doctor` (`doctor_id`)
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `schedules`
--

DROP TABLE IF EXISTS `schedules`;
CREATE TABLE IF NOT EXISTS `schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `date` date NOT NULL,
  `shift` varchar(50) NOT NULL,
  `slot` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_schedule_doctor_date_shift` (`doctor_id`,`date`,`shift`)
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `specialty`
--

DROP TABLE IF EXISTS `specialty`;
CREATE TABLE IF NOT EXISTS `specialty` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_specialty_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `time_slots`
--

DROP TABLE IF EXISTS `time_slots`;
CREATE TABLE IF NOT EXISTS `time_slots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `schedule_id` int NOT NULL,
  `start` time NOT NULL,
  `end` time NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'available',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_time_slot_schedule_time` (`schedule_id`,`start`,`end`),
  KEY `idx_time_slots_status` (`status`)
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_email` (`email`),
  KEY `idx_user_role` (`role`),
  KEY `idx_user_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `fk_appointments_information` FOREIGN KEY (`information_id`) REFERENCES `information` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `doctor`
--
ALTER TABLE `doctor`
  ADD CONSTRAINT `fk_doctor_specialty` FOREIGN KEY (`specialty_id`) REFERENCES `specialty` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doctor_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `information`
--
ALTER TABLE `information`
  ADD CONSTRAINT `fk_information_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `medical_records`
--
ALTER TABLE `medical_records`
  ADD CONSTRAINT `fk_medical_records_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reviews_information` FOREIGN KEY (`information_id`) REFERENCES `information` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `fk_schedules_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `time_slots`
--
ALTER TABLE `time_slots`
  ADD CONSTRAINT `fk_appointments_slot` FOREIGN KEY (`id`) REFERENCES `appointments` (`slot_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_time_slots_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
