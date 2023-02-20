-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 20, 2023 at 10:50 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ym_accountacy`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_clients` ()   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE id_, name_, email_ VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT id, name, email FROM customers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT 'id', 'name', 'email' UNION ALL SELECT @id, @name, @email;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO id_, name_, email_;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT id_, name_, email_ UNION ALL SELECT id_, name_, email_;
    END LOOP;

    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_clients_with_limit` ()   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE id_, name_, email_ VARCHAR(255);
    DECLARE cur CURSOR FOR
        SELECT id, name, email FROM customers LIMIT 2000;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT 'id', 'name', 'email' UNION ALL SELECT @id, @name, @email;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO id_, name_, email_;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT id_, name_, email_;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `app_client_pages`
--

CREATE TABLE `app_client_pages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pageId` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attrib_shops`
--

CREATE TABLE `attrib_shops` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attrib_shops`
--

INSERT INTO `attrib_shops` (`id`, `user_id`, `shop_id`, `created_at`, `updated_at`) VALUES
(1, 7, 3, NULL, NULL),
(2, 7, 4, NULL, NULL),
(3, 5, 3, NULL, NULL),
(4, 1, 12, NULL, NULL),
(5, 9, 12, NULL, NULL),
(6, 8, 1, NULL, NULL),
(7, 8, 2, NULL, NULL),
(8, 11, 3, NULL, NULL),
(9, 11, 4, NULL, NULL),
(10, 11, 5, NULL, NULL),
(11, 12, 1, NULL, NULL),
(12, 12, 3, NULL, NULL),
(13, 12, 11, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `balances`
--

CREATE TABLE `balances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `amount` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency` int(11) NOT NULL,
  `transaction_type` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `balances`
--

INSERT INTO `balances` (`id`, `amount`, `currency`, `transaction_type`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, '114.9', 1, 0, 1, 8, '2023-01-27 02:28:01', '2023-01-28 14:23:42'),
(2, '0', 2, 0, 1, 8, '2023-01-27 02:28:01', '2023-01-28 04:50:10'),
(3, '29.5', 1, 1, 1, 8, '2023-01-27 02:28:01', '2023-01-28 13:44:04'),
(4, '0', 2, 1, 1, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(5, '0', 1, 0, 2, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(6, '0', 2, 0, 2, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(7, '0', 1, 1, 2, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(8, '0', 2, 1, 2, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(9, '0', 1, 0, 12, 9, '2023-01-27 04:00:50', '2023-01-27 04:00:50'),
(10, '0', 2, 0, 12, 9, '2023-01-27 04:00:50', '2023-01-27 04:00:50'),
(11, '0', 1, 1, 12, 9, '2023-01-27 04:00:50', '2023-01-27 04:00:50'),
(12, '0', 2, 1, 12, 9, '2023-01-27 04:00:50', '2023-01-27 04:00:50'),
(37, '289.6', 1, 0, 3, 11, '2023-01-29 02:05:34', '2023-02-20 04:58:04'),
(38, '0', 2, 0, 3, 11, '2023-01-29 02:05:34', '2023-02-09 07:43:06'),
(39, '2.5', 1, 1, 3, 11, '2023-01-29 02:05:34', '2023-02-09 09:56:24'),
(40, '50', 2, 1, 3, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(41, '0', 1, 0, 4, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(42, '0', 2, 0, 4, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(43, '0', 1, 1, 4, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(44, '0', 2, 1, 4, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(45, '0', 1, 0, 5, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(46, '0', 2, 0, 5, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(47, '0', 1, 1, 5, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(48, '0', 2, 1, 5, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(157, '300', 1, 0, 1, 12, '2023-01-29 14:51:33', '2023-01-29 15:12:32'),
(158, '0', 2, 0, 1, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(159, '50', 1, 1, 1, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(160, '0', 2, 1, 1, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(161, '0', 1, 0, 3, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(162, '0', 2, 0, 3, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(163, '0', 1, 1, 3, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(164, '0', 2, 1, 3, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(165, '0', 1, 0, 11, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(166, '0', 2, 0, 11, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(167, '0', 1, 1, 11, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(168, '0', 2, 1, 11, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33');

-- --------------------------------------------------------

--
-- Table structure for table `balance_histories`
--

CREATE TABLE `balance_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `amount` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency` int(11) NOT NULL,
  `transaction_type` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `balance_histories`
--

INSERT INTO `balance_histories` (`id`, `amount`, `currency`, `transaction_type`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, '29.5', 1, 1, 1, 8, '2023-01-28', NULL),
(2, '114.9', 1, 0, 1, 8, '2023-01-28', '2023-01-28 14:23:42'),
(3, '10', 1, 0, 3, 11, '2023-01-29', '2023-01-29 09:45:53'),
(4, '6', 1, 1, 3, 11, '2023-01-29', NULL),
(5, '300', 1, 0, 3, 11, '2023-01-31', '2023-01-29 15:12:32'),
(7, '2.2', 1, 0, 3, 11, '2023-02-01', NULL),
(8, '6.7', 1, 0, 3, 11, '2023-02-06', '2023-02-06 09:13:05'),
(9, '178.2', 1, 0, 3, 11, '2023-02-09', '2023-02-09 10:26:49'),
(10, '278.5', 1, 1, 3, 11, '2023-02-09', '2023-02-09 09:56:24'),
(11, '0', 2, 0, 3, 11, '2023-02-09', '2023-02-09 07:43:06'),
(12, '50', 2, 1, 3, 11, '2023-02-09', NULL),
(13, '274', 1, 0, 3, 11, '2023-02-10', '2023-02-10 05:06:45'),
(14, '277.6', 1, 0, 3, 11, '2023-02-16', '2023-02-16 07:22:55'),
(15, '289.6', 1, 0, 3, 11, '2023-02-20', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cash_histories`
--

CREATE TABLE `cash_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `amount` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `out_qty` int(11) NOT NULL,
  `currency` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `transaction_type` int(11) NOT NULL,
  `accountancy_code` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cash_histories`
--

INSERT INTO `cash_histories` (`id`, `amount`, `comment`, `out_qty`, `currency`, `status`, `transaction_type`, `accountancy_code`, `client`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, '12', 'Vente T-shirt', 1, 1, 1, 0, '21', '0', 1, 8, '2023-01-28', '2023-01-28 10:39:26'),
(2, '1.4', 'PAIEMENT DE LA DETTE / Ali-Dieume', 0, 1, 1, 0, '21', '0', 1, 8, '2023-01-28', '2023-01-28 13:13:08'),
(3, '12', 'Vente T-shirt', 1, 1, 1, 1, '21', '13', 1, 8, '2023-01-28', '2023-01-28 13:44:04'),
(4, '10.5', 'Vente Drosty', 1, 1, 1, 1, '21', '13', 1, 8, '2023-01-28', '2023-01-28 13:44:04'),
(5, '12', 'Vente T-shirt', 1, 1, 1, 0, '21', '11', 1, 8, '2023-01-28', '2023-01-28 13:46:05'),
(6, '10.5', 'Vente Drosty', 1, 1, 1, 0, '21', '11', 1, 8, '2023-01-28', '2023-01-28 13:46:05'),
(7, '12', 'Vente T-shirt', 1, 1, 1, 0, '21', 'P./Prince', 1, 8, '2023-01-28', '2023-01-28 14:20:22'),
(8, '12', 'Vente T-shirt', 1, 1, 1, 0, '21', 'P./Prince', 1, 8, '2023-01-28', '2023-01-28 14:23:42'),
(9, '1.2', 'Vente Novida', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-01-29', '2023-01-29 02:38:40'),
(10, '1.3', 'Vente Jus-afia', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-01-29', '2023-01-29 02:38:40'),
(11, '1.2', 'Vente Novida', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-01-29', '2023-01-29 09:29:00'),
(12, '1.3', 'Vente Jus-afia', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-01-29', '2023-01-29 09:29:00'),
(13, '1.2', 'Vente Novida', 1, 1, 1, 0, '61', '', 3, 11, '2023-01-29', '2023-01-29 09:30:40'),
(14, '1', 'PAIEMENT DE LA DETTE / PRINCE AKILI', 0, 1, 1, 0, '61', NULL, 3, 11, '2023-01-29', '2023-01-29 09:35:19'),
(15, '0.5', 'PAIEMENT DE LA DETTE / PRINCE AKILI', 0, 1, 1, 0, '61', NULL, 3, 11, '2023-01-29', '2023-01-29 09:38:24'),
(16, '0.7', 'TRANSPORT BOSS', 0, 1, 2, 0, '61', NULL, 3, 11, '2023-01-29', '2023-01-29 09:45:32'),
(17, '6', 'TRANSFERT BANQUE', 0, 1, 2, 0, '61', NULL, 3, 11, '2023-01-29', '2023-01-29 09:45:53'),
(18, '6', 'TRANSFERT BANQUE', 0, 1, 1, 1, '61', NULL, 3, 11, '2023-01-29', '2023-01-29 09:45:53'),
(19, '150', 'Vente Hp', 1, 1, 1, 0, '57', 'P./BEN', 1, 12, '2023-01-29', '2023-01-29 15:05:42'),
(20, '200', 'Vente Hp', 1, 1, 1, 0, '57', 'P./BEN', 1, 12, '2023-01-29', '2023-01-29 15:05:42'),
(21, '50', 'Transfert', 0, 1, 2, 0, '57', NULL, 1, 12, '2023-01-29', '2023-01-29 15:12:32'),
(22, '50', 'Transfert', 0, 1, 1, 1, '57', NULL, 1, 12, '2023-01-29', '2023-01-29 15:12:32'),
(23, '1.2', 'Vente Novida', 1, 1, 1, 0, '45', 'P./PRINCE AKILI', 3, 11, '2023-01-29', '2023-01-29 20:08:15'),
(24, '0.9', 'Vente Amidol', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-02-06', '2023-02-06 09:01:48'),
(25, '2.6', 'Vente Jus-afia', 2, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-02-06', '2023-02-06 09:01:48'),
(26, '1.3', 'Vente Jus-afia', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-02-06', '2023-02-06 09:01:48'),
(34, '1', 'D', 0, 1, 1, 0, '61', 'CHNONOR', 3, 11, '2023-02-09', '2023-02-09 07:29:36'),
(35, '1', 'W', 0, 1, 2, 0, '61', 'CHNONOR', 3, 11, '2023-02-09', '2023-02-09 07:30:14'),
(36, '1', 'W', 0, 1, 1, 1, '61', 'CHNONOR', 3, 11, '2023-02-09', '2023-02-09 07:30:14'),
(37, '1', 'D', 0, 1, 1, 0, '61', 'JOHSN_IJ', 3, 11, '2023-02-09', '2023-02-09 07:37:21'),
(38, '1', 'W', 0, 1, 2, 0, '61', 'CHNONOR', 3, 11, '2023-02-09', '2023-02-09 07:37:54'),
(39, '10', 'D', 0, 1, 1, 0, '61', 'CHNONOR', 3, 11, '2023-02-09', '2023-02-09 07:40:02'),
(40, '100', 'D', 0, 2, 1, 0, '61', 'JOHSN_IJ', 3, 11, '2023-02-09', '2023-02-09 07:40:39'),
(41, '50', 'W', 0, 2, 2, 0, '45', 'JOHSN_IJ', 3, 11, '2023-02-09', '2023-02-09 07:40:58'),
(42, '1', 'T', 0, 1, 2, 0, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 07:41:51'),
(43, '1', 'T', 0, 1, 1, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 07:41:51'),
(44, '50', 'T', 0, 2, 2, 0, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 07:43:06'),
(45, '50', 'T', 0, 2, 1, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 07:43:06'),
(46, '100', 'D', 0, 1, 1, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 07:45:08'),
(47, '2', 'W', 0, 1, 1, 0, '61', 'ISAAC', 3, 11, '2023-02-09', '2023-02-09 07:48:10'),
(48, '2', 'W', 0, 1, 2, 1, '61', 'ISAAC', 3, 11, '2023-02-09', '2023-02-09 07:48:10'),
(49, '2', 'W', 0, 1, 1, 0, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 07:51:15'),
(50, '2', 'W', 0, 1, 2, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 07:51:15'),
(51, '50', 'W', 0, 1, 1, 0, '61', 'Bienfait', 3, 11, '2023-02-09', '2023-02-09 07:58:01'),
(52, '50', 'W', 0, 1, 2, 1, '61', 'Bienfait', 3, 11, '2023-02-09', '2023-02-09 07:58:01'),
(53, '10', 'W', 0, 1, 2, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 08:00:08'),
(54, '1', 'D', 0, 1, 1, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 08:01:28'),
(55, '5', 'D', 0, 1, 1, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 08:08:31'),
(56, '5', 'D', 0, 1, 1, 1, '61', 'PRINCE AKILI', 3, 11, '2023-02-09', '2023-02-09 08:09:23'),
(57, '1', 'd', 0, 1, 1, 1, '61', 'ISAAC', 3, 11, '2023-02-09', '2023-02-09 08:09:57'),
(58, '5', 'D', 0, 1, 1, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 08:11:12'),
(59, '1', 'D', 0, 1, 1, 1, '61', 'JOHSN_IJ', 3, 11, '2023-02-09', '2023-02-09 08:14:02'),
(60, '10', 'W', 0, 1, 2, 1, '61', 'ISAAC', 3, 11, '2023-02-09', '2023-02-09 08:31:32'),
(61, '100', 'D', 0, 1, 1, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 08:34:05'),
(62, '80', 'W', 0, 1, 2, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 08:35:02'),
(64, '100', 'W', 0, 1, 2, 1, '61', 'BING', 3, 11, '2023-02-09', '2023-02-09 08:35:37'),
(65, '1.2', 'Vente Novidas', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-02-09', '2023-02-09 09:54:57'),
(66, '1.3', 'Vente Jus-afia', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-02-09', '2023-02-09 09:54:57'),
(67, '1.2', 'Vente Novidas', 1, 1, 1, 1, '61', 'P./ISAAC', 3, 11, '2023-02-09', '2023-02-09 09:56:24'),
(68, '1.3', 'Vente Jus-afia', 1, 1, 1, 1, '61', 'P./ISAAC', 3, 11, '2023-02-09', '2023-02-09 09:56:24'),
(69, '1', 'PAIEMENT DE LA DETTE /PRINCE AKILI', 0, 1, 1, 0, '61', 'PRINCE AKILI', 3, 11, '2023-02-09', '2023-02-09 10:26:49'),
(70, '12', 'D', 0, 1, 1, 0, '61', 'ISAAC', 3, 11, '2023-02-10', '2023-02-10 05:04:53'),
(71, '2', 'R', 0, 1, 2, 0, '61', 'BING', 3, 11, '2023-02-10', '2023-02-10 05:05:20'),
(72, '2', 'R', 0, 1, 2, 0, '61', 'ISAAC', 3, 11, '2023-02-10', '2023-02-10 05:05:43'),
(73, '1', 'PAIEMENT DE LA DETTE /PRINCE AKILI', 0, 1, 1, 0, '61', 'PRINCE AKILI', 3, 11, '2023-02-10', '2023-02-10 05:06:04'),
(76, '1.2', 'Novidas', 1, 1, 1, 0, '61', 'P./CHNONOR', 3, 11, '2023-02-16', '2023-02-16 07:16:42'),
(77, '1.2', 'Novidas', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-02-16', '2023-02-16 07:21:49'),
(78, '1.2', 'Vente avec livraisonNovidas', 1, 1, 1, 0, '61', 'P./PRINCE AKILI', 3, 11, '2023-02-16', '2023-02-16 07:22:55'),
(79, '12', 'D', 0, 1, 1, 0, '61', 'PRINCE AKILI', 3, 11, '2023-02-20', '2023-02-20 04:58:04');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `category_name`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 'Wisky', 1, 1, '2023-01-06 13:27:51', '2023-01-06 13:27:51'),
(2, 'Jus', 1, 1, '2023-01-06 13:28:31', '2023-01-06 13:28:31'),
(3, 'Soda', 1, 1, '2023-01-06 13:28:37', '2023-01-06 13:28:37'),
(4, 'Meal', 1, 1, '2023-01-06 13:28:51', '2023-01-06 13:28:51'),
(5, 'Electronics', 1, 1, '2023-01-06 13:35:15', '2023-01-22 06:08:20'),
(6, 'MILK', 2, 1, '2023-01-15 15:01:25', '2023-01-15 15:01:25'),
(7, 'HABITS', 1, 8, '2023-01-26 06:37:08', '2023-01-26 06:37:21'),
(8, 'JUS', 3, 11, '2023-01-29 01:40:20', '2023-01-29 01:40:20'),
(9, 'Water', 3, 11, '2023-01-29 01:40:29', '2023-01-29 02:32:19'),
(10, 'ORDINATEUR', 1, 12, '2023-01-29 14:42:08', '2023-01-29 14:42:21'),
(11, 'TELEPHONE', 1, 12, '2023-01-29 14:43:49', '2023-01-29 14:43:49'),
(12, 'LIVRE', 1, 12, '2023-01-29 14:44:14', '2023-01-29 14:44:14'),
(13, 'CODE', 1, 12, '2023-01-29 14:44:25', '2023-01-29 14:44:25'),
(14, 'ANTIBIOTIQUE', 3, 11, '2023-02-06 08:49:56', '2023-02-06 08:49:56');

-- --------------------------------------------------------

--
-- Table structure for table `code_ohadas`
--

CREATE TABLE `code_ohadas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `code_ohadas`
--

INSERT INTO `code_ohadas` (`id`, `code`, `name`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(2, '52', 'Banque', 1, 1, '2023-01-24 13:10:04', '2023-01-24 13:10:04'),
(3, '41', 'Client', 1, 1, '2023-01-24 13:11:55', '2023-01-24 13:11:55'),
(4, '57', 'CAISSE', 1, 1, '2023-01-25 03:16:15', '2023-01-25 03:16:15'),
(5, '10', 'CAPITALE', 1, 1, '2023-01-25 03:16:24', '2023-01-25 03:16:24'),
(6, '31', 'ACHAT-MARCHANDISE', 1, 1, '2023-01-25 03:16:37', '2023-01-25 03:16:37'),
(7, '56', 'PERTE', 1, 1, '2023-01-25 03:16:47', '2023-01-25 03:16:47'),
(8, '345', 'INVESTISSEMENT', 1, 1, '2023-01-25 03:17:01', '2023-01-25 03:17:01'),
(9, '24', 'IMMOBILIER', 1, 1, '2023-01-25 03:20:00', '2023-01-25 03:20:00'),
(10, '484', 'AVANCE SUR SALAIRE', 1, 1, '2023-01-25 03:20:16', '2023-01-25 03:20:16'),
(11, '61', 'ENCAISSEMENT CHEQUE', 1, 1, '2023-01-25 03:20:35', '2023-01-25 03:20:35'),
(12, '13', 'DETTE', 1, 1, '2023-01-25 03:20:48', '2023-01-25 03:20:48'),
(13, '21', 'VENTE', 1, 8, '2023-01-26 12:13:54', '2023-01-26 12:13:54'),
(14, '61', 'FOURNITURE', 1, 8, '2023-01-27 04:04:38', '2023-01-27 04:04:38'),
(15, '57', 'CAISSE', 1, 8, '2023-01-28 04:43:26', '2023-01-28 04:43:26'),
(16, '61', 'VENTE', 3, 11, '2023-01-29 02:38:06', '2023-01-29 02:38:06'),
(17, '57', 'CAISSE', 1, 12, '2023-01-29 15:03:57', '2023-01-29 15:04:31'),
(18, '45', 'Vente', 3, 11, '2023-01-29 20:03:22', '2023-01-29 20:03:22');

-- --------------------------------------------------------

--
-- Table structure for table `currency_settings`
--

CREATE TABLE `currency_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `currency_settings`
--

INSERT INTO `currency_settings` (`id`, `name`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 'USD', 1, 1, NULL, NULL),
(2, 'FC', 1, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` tinyint(1) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `email`, `telephone`, `type`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 'John-does', 'doe23@gmail.com', '+243991653604', 0, 1, 1, '2023-01-06 13:07:28', '2023-01-22 03:50:08'),
(2, 'Joseph-Akili', NULL, NULL, 0, 1, 1, '2023-01-10 10:11:50', '2023-01-10 10:11:50'),
(3, 'KINSHOP', 'kin@gmail.com', '09927383763', 0, 1, 1, '2023-01-10 12:26:27', '2023-01-10 12:26:27'),
(5, 'KINSHOP', 'kin@fmail.com', '0938374838', 0, 1, 1, '2023-01-10 12:30:19', '2023-01-10 12:30:19'),
(7, 'LINDA', 'linda@gmail.com', NULL, 0, 1, 1, '2023-01-20 07:52:03', '2023-01-20 07:52:03'),
(8, 'JEREMIE BD', NULL, NULL, 0, 1, 1, '2023-01-20 07:55:33', '2023-01-20 07:55:33'),
(9, 'BENJAMIN', 'benjamin@gmail.com', NULL, 0, 1, 1, '2023-01-22 06:19:34', '2023-01-22 06:19:34'),
(10, 'SHAKIRA', NULL, NULL, 0, 1, 1, '2023-01-24 11:25:28', '2023-01-24 11:25:28'),
(11, 'JOHNNY', 'john@gmail.com', NULL, 0, 1, 8, '2023-01-26 12:16:26', '2023-01-28 09:00:51'),
(12, 'EMMANUEL', NULL, NULL, 0, 1, 8, '2023-01-27 04:05:03', '2023-01-27 04:05:03'),
(13, 'Ars', NULL, NULL, 0, 1, 8, NULL, NULL),
(14, 'Dog-serne', 'doger@gmail.com', NULL, 1, 1, 8, NULL, '2023-01-28 09:21:09'),
(15, 'Ali-Dieume', 'didueme@gmail.com', '099283738', 0, 1, 8, NULL, '2023-01-28 09:28:45'),
(16, 'Prince', NULL, NULL, 1, 1, 8, NULL, NULL),
(17, 'PRINCE AKILI', 'prince@gmail.com', NULL, 1, 3, 11, '2023-01-29 02:37:24', '2023-01-29 02:37:24'),
(18, 'd', NULL, '094483938', 0, 3, 11, '2023-01-29 02:52:58', '2023-01-29 02:52:58'),
(19, 'Bienfait', NULL, '09917634', 0, 3, 11, '2023-01-29 09:30:22', '2023-01-29 09:30:22'),
(20, 'BEN', 'ijamboizuba20@gmail.com', '+243991653604', 1, 1, 12, '2023-01-29 15:01:32', '2023-01-29 15:01:32'),
(21, 'ANGEL', 'ANGEL@gmail.com', '+243991653608', 0, 1, 12, '2023-01-29 15:02:00', '2023-01-29 15:02:00'),
(22, 'ISAAC', NULL, '099927383', 0, 3, 11, '2023-01-29 20:10:22', '2023-01-29 20:10:22'),
(23, 'BING', NULL, '30394', 0, 3, 11, '2023-01-29 20:12:39', '2023-01-29 20:12:39'),
(24, 'CHNONOR', NULL, '098384', 1, 3, 11, '2023-01-29 20:12:53', '2023-01-29 20:12:53'),
(25, 'JOHSN_IJ', NULL, '09585768575784', 0, 3, 11, '2023-02-06 09:12:09', '2023-02-06 09:15:36');

-- --------------------------------------------------------

--
-- Table structure for table `customer_fidelities`
--

CREATE TABLE `customer_fidelities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` int(11) NOT NULL,
  `amount` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_fidelities`
--

INSERT INTO `customer_fidelities` (`id`, `customer_id`, `amount`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 1, '481', 1, 1, NULL, NULL),
(2, 2, '97', 1, 1, NULL, NULL),
(3, 7, '98', 1, 1, NULL, NULL),
(4, 8, '70', 1, 1, NULL, NULL),
(5, 9, '96', 1, 1, NULL, NULL),
(6, 3, '12', 1, 1, NULL, NULL),
(7, 5, '24', 1, 1, NULL, NULL),
(11, 11, '155.5', 1, 8, NULL, NULL),
(12, 12, '139', 1, 8, NULL, NULL),
(13, 14, '12', 1, 8, NULL, NULL),
(14, 15, '44.4', 1, 8, NULL, NULL),
(15, 13, '22.5', 1, 8, NULL, NULL),
(16, 16, '24', 1, 8, NULL, NULL),
(17, 17, '21.9', 3, 11, NULL, NULL),
(18, 19, '1.2', 3, 11, NULL, NULL),
(19, 20, '350', 1, 12, NULL, NULL),
(20, 25, '1.3', 3, 11, NULL, NULL),
(21, 22, '2.5', 3, 11, NULL, NULL),
(22, 24, '1.2', 3, 11, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `debt_balances`
--

CREATE TABLE `debt_balances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` int(11) NOT NULL,
  `total_amount` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `debt_balances`
--

INSERT INTO `debt_balances` (`id`, `customer_id`, `total_amount`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(2, 1, '21', 1, 1, NULL, NULL),
(3, 7, '10', 1, 1, NULL, NULL),
(4, 8, '0', 1, 1, NULL, NULL),
(5, 9, '53', 1, 1, NULL, NULL),
(6, 11, '35', 1, 8, NULL, NULL),
(8, 14, '12', 1, 8, NULL, NULL),
(9, 15, '21.1', 1, 8, NULL, NULL),
(10, 17, '0.2', 3, 11, NULL, NULL),
(11, 25, '4.1', 3, 11, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `debt_payment_histories`
--

CREATE TABLE `debt_payment_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` int(11) NOT NULL,
  `paid_amount` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `debt_payment_histories`
--

INSERT INTO `debt_payment_histories` (`id`, `customer_id`, `paid_amount`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(2, 7, '10', 1, 1, NULL, NULL),
(3, 7, '4', 1, 1, NULL, NULL),
(4, 7, '10', 1, 1, NULL, NULL),
(5, 8, '35', 1, 1, NULL, NULL),
(6, 9, '10', 1, 1, NULL, NULL),
(7, 1, '10', 1, 1, NULL, NULL),
(8, 1, '10', 1, 1, NULL, NULL),
(9, 1, '10', 1, 1, NULL, NULL),
(10, 7, '10', 1, 1, NULL, NULL),
(11, 1, '10', 1, 1, NULL, NULL),
(12, 7, '10', 1, 1, NULL, NULL),
(13, 11, '12', 1, 8, NULL, NULL),
(14, 11, '12', 1, 8, NULL, NULL),
(15, 11, '1', 1, 8, NULL, NULL),
(16, 15, '1.4', 1, 8, NULL, NULL),
(21, 17, '1', 3, 11, NULL, NULL),
(22, 17, '0.5', 3, 11, NULL, NULL),
(23, 25, '1.3', 3, 11, NULL, NULL),
(26, 17, '1', 3, 11, NULL, NULL),
(27, 17, '1', 3, 11, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2019_08_19_000000_create_failed_jobs_table', 1),
(3, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(4, '2022_11_14_104332_create_categories_table', 1),
(5, '2022_11_14_104344_create_products_table', 1),
(6, '2022_11_14_104357_create_stocks_table', 1),
(7, '2022_11_14_104416_create_customers_table', 1),
(8, '2022_11_15_201318_create_prices_table', 1),
(9, '2022_11_15_210724_create_supply_stocks_table', 1),
(10, '2022_11_17_100254_create_units_table', 1),
(11, '2022_11_17_104323_create_ym_customers_table', 1),
(12, '2022_11_17_123645_create_attrib_shops_table', 1),
(13, '2022_11_17_123751_create_shops_table', 1),
(14, '2022_11_19_114148_create_balances_table', 1),
(15, '2022_11_21_104944_create_cash_histories_table', 1),
(16, '2022_11_22_103147_create_price_settings_table', 1),
(17, '2022_11_22_103342_create_currency_settings_table', 1),
(18, '2022_12_05_091011_create_settings_table', 1),
(19, '2022_12_07_093225_create_spaces_table', 1),
(20, '2022_12_07_093319_create_tables_table', 1),
(21, '2022_12_10_120454_create_out_product_qties_table', 1),
(22, '2022_12_14_080207_create_orders_table', 1),
(23, '2022_12_15_044521_create_selected_products_table', 1),
(24, '2023_01_02_173001_create_balance_histories_table', 1),
(25, '2023_01_03_082629_create_debt_balances_table', 1),
(26, '2023_01_03_082846_create_debt_payment_histories_table', 1),
(27, '2023_01_03_084820_create_customer_fidelities_table', 1),
(29, '2023_01_24_142026_create_code_ohadas_table', 2),
(31, '2023_01_27_084906_create_ticketings_table', 3),
(33, '2023_01_31_105230_create_roles_table', 4),
(34, '2023_01_31_105510_create_user_roles_table', 5),
(35, '2023_01_31_113937_create_user_actions_table', 6),
(36, '2023_01_31_114000_create_user_shop_to_acesses_table', 6),
(37, '2023_01_31_114047_create_user_page_to_acesses_table', 6),
(38, '2023_01_31_114106_create_user_action_to_makes_table', 6),
(39, '2023_01_31_115307_create_app_client_pages_table', 6);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_id` int(11) NOT NULL,
  `count_product` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `space_id` int(11) NOT NULL,
  `table_id` int(11) NOT NULL,
  `is_deletable` int(11) NOT NULL,
  `payment_type` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `start_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `end_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hidden_row_status` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `client_name`, `client_id`, `count_product`, `status`, `space_id`, `table_id`, `is_deletable`, `payment_type`, `user_id`, `start_date`, `end_date`, `comment`, `hidden_row_status`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 'Commande', 0, 0, 2, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-10 09:42:48', '2023-01-10 11:29:19'),
(3, 'commande', 0, 2, 2, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-18 07:30:08', '2023-01-19 12:14:46'),
(4, 'Jeremie', 0, 3, 2, 2, 4, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-19 06:53:39', '2023-01-19 11:39:15'),
(5, 'John-does', 1, 1, 2, 1, 1, 0, 3, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-19 07:26:15', '2023-01-25 10:54:51'),
(6, 'COMMANDE', 0, 3, 2, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-19 13:50:57', '2023-01-20 07:19:57'),
(7, 'Commande', 0, 2, 2, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-19 13:54:19', '2023-01-20 07:53:30'),
(8, 'commande', 0, 3, 2, 2, 4, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-20 07:36:53', '2023-01-20 07:51:24'),
(9, 'commande', 0, 3, 2, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-20 07:54:34', '2023-01-20 07:56:22'),
(10, 'LINDA', 7, 2, 2, 1, 1, 0, 5, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-20 08:45:45', '2023-01-20 08:55:27'),
(12, 'BENJAMIN', 9, 2, 2, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-20 10:11:24', '2023-01-22 06:19:57'),
(14, 'BENJAMIN', 9, 2, 2, 2, 4, 0, 5, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-22 06:14:05', '2023-01-22 06:20:37'),
(15, 'John-does', 1, 2, 2, 2, 4, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-23 15:04:43', '2023-01-25 10:35:35'),
(16, 'John-does', 1, 1, 2, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-25 10:36:20', '2023-01-25 10:36:37'),
(17, 'KINSHOP', 3, 1, 2, 2, 4, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-25 10:38:01', '2023-01-25 10:42:33'),
(18, 'Joseph-Akili', 2, 1, 2, 2, 4, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-25 10:42:55', '2023-01-25 10:43:43'),
(19, 'KINSHOP', 5, 1, 2, 1, 1, 0, 3, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-25 10:45:39', '2023-01-25 10:49:00'),
(20, 'John-does', 1, 1, 2, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-25 11:02:20', '2023-01-25 11:03:00'),
(21, 'John-does', 1, 1, 2, 1, 1, 0, 3, 1, NULL, NULL, NULL, 0, 1, 1, '2023-01-25 11:03:52', '2023-01-25 11:04:15'),
(27, 'JOHNNY', 11, 1, 3, 6, 8, 0, 1, 9, NULL, NULL, NULL, 0, 1, 8, '2023-01-26 10:32:54', '2023-01-26 12:54:12'),
(28, 'JOHNNY', 11, 1, 3, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-26 11:44:51', '2023-01-26 12:48:42'),
(29, 'JOHNNY', 11, 1, 2, 6, 8, 0, 3, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-26 13:02:06', '2023-01-26 13:09:01'),
(30, 'EMMANUEL', 12, 1, 2, 6, 8, 0, 3, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-27 04:03:12', '2023-01-27 04:05:24'),
(31, 'JOHNNY', 11, 2, 2, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 03:28:33', '2023-01-28 03:29:32'),
(32, 'JOHNNY', 11, 1, 2, 6, 8, 0, 5, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 04:22:50', '2023-01-28 04:35:49'),
(33, 'JOHNNY', 11, 2, 2, 6, 8, 0, 5, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 04:44:16', '2023-01-28 04:45:03'),
(34, 'JOHNNY', 11, 1, 2, 6, 8, 0, 5, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 04:45:33', '2023-01-28 04:46:01'),
(35, 'EMMANUEL', 12, 3, 2, 6, 8, 0, 5, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 04:51:27', '2023-01-28 10:22:23'),
(36, 'Commande', 0, 1, 2, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 09:43:24', '2023-01-28 10:33:43'),
(37, 'Commande', 0, 1, 2, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 10:39:04', '2023-01-28 10:39:26'),
(38, 'Commande', 0, 2, 3, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 10:39:46', '2023-01-28 12:27:04'),
(39, 'Dog-serne', 14, 1, 3, 6, 8, 0, 4, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 10:41:49', '2023-01-28 12:24:23'),
(40, 'JOHNNY', 11, 1, 2, 6, 8, 0, 4, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 12:43:22', '2023-01-28 12:44:56'),
(41, 'Ali-Dieume', 15, 2, 2, 6, 8, 0, 4, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 12:47:16', '2023-01-28 13:12:42'),
(42, 'Commande', 0, 2, 2, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 13:43:23', '2023-01-28 13:44:04'),
(43, 'Commande', 0, 2, 3, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 13:45:33', '2023-01-28 14:11:12'),
(44, 'Commande', 0, 1, 2, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 14:11:19', '2023-01-28 14:20:22'),
(45, 'Commande', 0, 1, 2, 6, 8, 0, 1, 6, NULL, NULL, NULL, 0, 1, 8, '2023-01-28 14:23:12', '2023-01-28 14:23:42'),
(46, 'Commande', 0, 2, 3, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-01-29 02:36:25', '2023-01-29 02:38:47'),
(47, 'PRINCE AKILI', 17, 2, 3, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-01-29 02:49:04', '2023-01-29 09:29:06'),
(48, 'Bienfait', 19, 1, 2, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-01-29 09:29:51', '2023-01-29 09:30:40'),
(49, 'PRINCE AKILI', 17, 2, 2, 6, 8, 0, 4, 11, NULL, NULL, NULL, 0, 3, 11, '2023-01-29 09:31:06', '2023-01-29 09:31:40'),
(51, 'BEN', 20, 2, 2, 6, 8, 0, 1, 16, NULL, NULL, NULL, 0, 1, 12, '2023-01-29 14:58:59', '2023-01-29 15:05:42'),
(52, 'PRINCE AKILI', 17, 1, 2, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-01-29 19:41:09', '2023-01-29 20:08:15'),
(53, 'PRINCE AKILI', 17, 1, 2, 6, 8, 0, 4, 11, NULL, NULL, NULL, 0, 3, 11, '2023-01-29 20:09:56', '2023-02-09 09:57:03'),
(54, 'PRINCE AKILI', 17, 3, 3, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-06 08:57:20', '2023-02-06 09:01:54'),
(55, 'JOHSN', 25, 2, 2, 6, 8, 0, 4, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-06 09:11:16', '2023-02-06 09:12:30'),
(56, 'JOHSN', 25, 2, 2, 6, 8, 0, 4, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-06 09:13:47', '2023-02-06 09:14:32'),
(57, 'ISAAC', 22, 2, 2, 6, 8, 0, 3, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-07 03:37:47', '2023-02-09 09:56:24'),
(58, 'PRINCE AKILI', 17, 2, 2, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-09 09:51:54', '2023-02-09 09:54:57'),
(59, 'CHNONOR', 24, 1, 2, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-09 10:47:48', '2023-02-16 07:16:42'),
(60, 'PRINCE AKILI', 17, 2, 2, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-10 05:06:18', '2023-02-10 05:06:45'),
(61, 'PRINCE AKILI', 17, 1, 3, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-16 07:19:30', '2023-02-20 04:49:59'),
(62, 'PRINCE AKILI', 17, 1, 3, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-16 07:22:19', '2023-02-20 04:49:57'),
(63, 'Commande', 0, 1, 1, 6, 8, 0, 1, 11, NULL, NULL, NULL, 0, 3, 11, '2023-02-20 04:50:32', '2023-02-20 04:50:40');

-- --------------------------------------------------------

--
-- Table structure for table `out_product_qties`
--

CREATE TABLE `out_product_qties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_qty` int(11) NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `out_product_qties`
--

INSERT INTO `out_product_qties` (`id`, `product_id`, `product_qty`, `comment`, `status`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 13, 1, 'Detruit', 0, 3, 11, '2023-01-29 02:34:45', '2023-01-29 02:34:45'),
(2, 16, 3, 'DJHRHHJDRHR', 0, 1, 12, '2023-01-29 14:54:39', '2023-01-29 14:54:39'),
(3, 13, 4, 'D', 0, 3, 11, '2023-01-29 19:24:58', '2023-01-29 19:24:58'),
(4, 20, 2, 'PERTE/DETRUIT', 0, 3, 11, '2023-02-06 08:56:15', '2023-02-06 08:56:15');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(44, 'App\\User', 2, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '0933bf0714c75f72e91a12a463bf20cc5ef5b655ca74c7e56749c1da297f3d40', '[\"*\"]', NULL, '2023-01-25 12:39:43', '2023-01-25 12:39:43'),
(46, 'App\\User', 2, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '1c7fba498f2b5aebd72cf387d1e9b368ad9ccf9c322e1a34287389ac6fd5b75c', '[\"*\"]', NULL, '2023-01-25 12:47:45', '2023-01-25 12:47:45'),
(48, 'App\\User', 3, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'e0f80111b490f4cc98c4778c4dd09a3d18aa5ab26d22928df1861ff039ce8641', '[\"*\"]', NULL, '2023-01-25 13:08:03', '2023-01-25 13:08:03'),
(49, 'App\\User', 4, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'd60a7ac3d53ab5d0ac90734e1b879f06e4863766f210755394474c4896e4c59b', '[\"*\"]', NULL, '2023-01-25 13:10:00', '2023-01-25 13:10:00'),
(52, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '74089560cdb4d5a45ffe184bc91dcc754c4d3ddae23c88d1e08389298121a49e', '[\"*\"]', NULL, '2023-01-26 02:48:19', '2023-01-26 02:48:19'),
(53, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '61ea072b23ad2a1e41a0e683660ab477857d515743a6f4cb7b6ddda5e12aa67f', '[\"*\"]', NULL, '2023-01-26 02:57:24', '2023-01-26 02:57:24'),
(54, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '1bc05edf2572c66bb7ba284be8b6a5611318e426cbd32beaa62f794367f93ff2', '[\"*\"]', NULL, '2023-01-26 03:17:48', '2023-01-26 03:17:48'),
(56, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'ca03474fb2eb5d79fb1f1279ad4a4aeb49489f6186a954edc2ea1a4be014955d', '[\"*\"]', NULL, '2023-01-26 03:24:03', '2023-01-26 03:24:03'),
(57, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '077f6514257e5f37ed3bc31a3aa00a56a247ee31ca50f318e0902bcfac7fd3bc', '[\"*\"]', NULL, '2023-01-26 03:30:11', '2023-01-26 03:30:11'),
(59, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '63a81b1e77adea6cf8918a89d3579e1bde130fbf8f9c76d266c27fa7154ea788', '[\"*\"]', NULL, '2023-01-26 03:32:30', '2023-01-26 03:32:30'),
(60, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '699f539846848e608df370f8fc7bb5dafc6d4c22e46d8c14bc9862c415f5e679', '[\"*\"]', NULL, '2023-01-26 03:34:52', '2023-01-26 03:34:52'),
(61, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '81cde2313a6cbe9887794730b1aaa4b45b4a28799b19c70fdf5e5ada309caede', '[\"*\"]', NULL, '2023-01-26 03:48:16', '2023-01-26 03:48:16'),
(63, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '3a0939aa24473383270f6541e6c717a23a09aa9b0d5526391e1e45c7c3fdc358', '[\"*\"]', NULL, '2023-01-26 04:03:25', '2023-01-26 04:03:25'),
(64, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '1c3169861bd91051b3ab959cba1f8aaa85be11eb48eb492c406d1f9e19f8de70', '[\"*\"]', NULL, '2023-01-26 04:14:00', '2023-01-26 04:14:00'),
(65, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '16c6755594404e59ae2e5cf121eb7bab0b4c038e986f78390a3e408889216c9a', '[\"*\"]', NULL, '2023-01-26 04:26:39', '2023-01-26 04:26:39'),
(69, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '81930e96e044f6294760bbe300a1fa373d5c72330acf74493566318d4153da54', '[\"*\"]', NULL, '2023-01-26 04:46:00', '2023-01-26 04:46:00'),
(71, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '03755eaed674eec54342dce1dd256a2d907a5c8d9e73bce17373bb3b9cfd8e38', '[\"*\"]', NULL, '2023-01-26 05:44:12', '2023-01-26 05:44:12'),
(74, 'App\\User', 5, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '5563208e48dcc33984ce3174c1d7a517e618a2e6119e3bc09f34c110d3f96e25', '[\"*\"]', NULL, '2023-01-26 05:57:11', '2023-01-26 05:57:11'),
(76, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'c3882a4615076f0bcb617a9478019eea0fe71a9aab7abeee3d638f49fb56f088', '[\"*\"]', NULL, '2023-01-26 06:17:14', '2023-01-26 06:17:14'),
(77, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'e09d80ad312f39ae454c32164423f9ae3e46af8c4dd318f2ec3bb49798fba0a7', '[\"*\"]', NULL, '2023-01-26 06:17:54', '2023-01-26 06:17:54'),
(78, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'a0ad01053d3f9b156322326a4c119d2fbf9a08bced66313dc03a1acdbbcf55ea', '[\"*\"]', NULL, '2023-01-26 06:21:13', '2023-01-26 06:21:13'),
(79, 'App\\User', 7, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '0f713c4d6c3d6724ac0530157a9ae9dd09eb6547da74b5d31a5a4acbf87bf192', '[\"*\"]', NULL, '2023-01-26 06:25:15', '2023-01-26 06:25:15'),
(82, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'fba6bc51cebd73ba24890efa5c70c0965915c479411cb5338e323d73c631ddfe', '[\"*\"]', NULL, '2023-01-26 06:27:46', '2023-01-26 06:27:46'),
(83, 'App\\User', 8, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'bec58c0bc38eff5291b879daf74400e7d8abe82cb6b0cb7051498500ff822eb4', '[\"*\"]', NULL, '2023-01-26 06:33:00', '2023-01-26 06:33:00'),
(84, 'App\\User', 9, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'a6a819d08f9e88177b833158fefbb6174008500e3427f0af4fb5d8723cc25239', '[\"*\"]', NULL, '2023-01-26 06:33:29', '2023-01-26 06:33:29'),
(87, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'db1daab8dda9a69ea948f2a3a47760823c58833eae8ce53b01525393f138379b', '[\"*\"]', NULL, '2023-01-26 06:58:34', '2023-01-26 06:58:34'),
(91, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '4c892d03cb1e42aa954a68ffab87db6cf715ee1cc5fee344a39b885d351cfb59', '[\"*\"]', NULL, '2023-01-26 07:21:25', '2023-01-26 07:21:25'),
(93, 'App\\User', 7, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'c084a662d13719d719199192dcfd36487aad4e7ebb72ee4186337b10c97a5b56', '[\"*\"]', NULL, '2023-01-26 07:26:57', '2023-01-26 07:26:57'),
(95, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'b597dacdd11f75ef5349539375e7871aaddb8141151ea0a1f6d43e04d399a3e3', '[\"*\"]', NULL, '2023-01-26 07:30:19', '2023-01-26 07:30:19'),
(96, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '649ef2f944a5bd3a0143adeb2b9974e1a01e38c5ad902e5246b38f081fb587e3', '[\"*\"]', NULL, '2023-01-26 08:16:19', '2023-01-26 08:16:19'),
(99, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '4206d74e9783cab2c633f1a33bcfaf6904cfeaa1eeed52f0a7fc064e9b29862a', '[\"*\"]', NULL, '2023-01-26 10:14:24', '2023-01-26 10:14:24'),
(100, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'd855359e61d1527c19d0c250da09bfd0f95f392c34c0a6c3909772e2589c9f08', '[\"*\"]', NULL, '2023-01-26 10:28:18', '2023-01-26 10:28:18'),
(102, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '4bc9e0793adbb8487601df75de5bd283d7bd738e4bd3d93ff988986d4fe714c3', '[\"*\"]', NULL, '2023-01-27 02:01:41', '2023-01-27 02:01:41'),
(104, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '3383b00aa7a56cca90d7328a428237d8d803cf477927a7b4fa9708ee2d95b659', '[\"*\"]', NULL, '2023-01-27 04:01:04', '2023-01-27 04:01:04'),
(106, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '62ee0e1b90ee29b37e76e5b71fc8b1dc8b37c3429774f60ee27e79e3a56eabf7', '[\"*\"]', NULL, '2023-01-28 01:38:48', '2023-01-28 01:38:48'),
(108, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '98b46ff73057722276e66b33943cfe788e45999164742461029f1658d380db8d', '[\"*\"]', NULL, '2023-01-28 05:05:06', '2023-01-28 05:05:06'),
(110, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '8df6e00c78d0c2321a1be8f5a5bae59dfd00cca2ca60469505b39a0786f447a6', '[\"*\"]', NULL, '2023-01-28 07:33:22', '2023-01-28 07:33:22'),
(113, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '7780917ce9845a7f44b1514196d60861bcc62ddd4f17f67e473e1148e8a83943', '[\"*\"]', NULL, '2023-01-28 11:26:31', '2023-01-28 11:26:31'),
(115, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '6aa8e76bf5f5983b38962b521ce459d31f655d7c1ed2540cd48eacf97b4810ad', '[\"*\"]', NULL, '2023-01-28 12:05:19', '2023-01-28 12:05:19'),
(117, 'App\\User', 6, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'b680443903c53f82d95cc15695a054ca61c593aa120f0fc3c2266bc19efd9cc7', '[\"*\"]', NULL, '2023-01-29 01:16:56', '2023-01-29 01:16:56'),
(119, 'App\\User', 10, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'eacfae98e7d6468156bec620ed392cb936823e76eff996442638ba44e1ba82a6', '[\"*\"]', NULL, '2023-01-29 01:28:47', '2023-01-29 01:28:47'),
(125, 'App\\User', 11, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '5c328b902987a85c09e508666ba0065e53566ea22d9d6ebead743f7d674c13c3', '[\"*\"]', '2023-01-29 02:42:49', '2023-01-29 02:31:39', '2023-01-29 02:42:49'),
(127, 'App\\User', 13, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '62e6761b0ee1d5a3146a3999f88e39146618a5d302c78678e61cbb5f440dfdc9', '[\"*\"]', NULL, '2023-01-29 02:42:18', '2023-01-29 02:42:18'),
(129, 'App\\User', 14, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '5e804989d0b5fe4cee623eda1511cb595ba3a61500de32a99c58807b2e4632ef', '[\"*\"]', NULL, '2023-01-29 02:45:17', '2023-01-29 02:45:17'),
(130, 'App\\User', 15, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '8c8b1df8ab9820015f241febebac709e214c2e35ddcb16275716cf4a8078f339', '[\"*\"]', NULL, '2023-01-29 02:45:58', '2023-01-29 02:45:58'),
(132, 'App\\User', 11, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', 'd20314f8db43def4f6646134202411999bc6297219615e620e76550dead091b2', '[\"*\"]', '2023-01-29 09:38:58', '2023-01-29 09:28:04', '2023-01-29 09:38:58'),
(142, 'App\\User', 16, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '4522da08d4a03689e476213bb857ac0c80ec2e3b34f680d6a45ae59fc8fa59f9', '[\"*\"]', '2023-01-29 15:13:45', '2023-01-29 14:51:30', '2023-01-29 15:13:45'),
(151, 'App\\User', 17, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '754027c2f738213961eba1094e64c70f70f12325498c057f67aa5fc035b8d133', '[\"*\"]', NULL, '2023-02-01 02:19:19', '2023-02-01 02:19:19'),
(179, 'App\\User', 12, 'X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=', '2341af1bd4fcb1a9cdd029cb343377c5c82160437704294a758f7e0b667b9e60', '[\"*\"]', '2023-02-20 06:25:47', '2023-02-20 05:01:45', '2023-02-20 06:25:47');

-- --------------------------------------------------------

--
-- Table structure for table `prices`
--

CREATE TABLE `prices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `prices`
--

INSERT INTO `prices` (`id`, `product_id`, `price`, `price_name`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 1, '12', 'Detail', 1, 1, '2023-01-06 13:39:24', '2023-01-06 13:39:24'),
(3, 2, '12', 'DETAIL', 1, 1, '2023-01-10 10:06:47', '2023-01-10 10:06:47'),
(4, 2, '10', 'GROS', 1, 1, '2023-01-18 09:34:16', '2023-01-18 09:34:16'),
(24, 3, '12', 'DETAIL', 1, 1, '2023-01-18 11:15:03', '2023-01-18 11:15:03'),
(25, 3, '13', 'GROS', 1, 1, '2023-01-18 11:21:44', '2023-01-18 11:21:44'),
(27, 5, '12', 'DETAIL', 1, 1, '2023-01-18 11:26:02', '2023-01-18 11:26:02'),
(28, 4, '12', 'DETAIL', 1, 1, '2023-01-18 11:29:03', '2023-01-18 11:29:03'),
(29, 4, '13', 'GROS', 1, 1, '2023-01-18 11:29:16', '2023-01-18 11:29:16'),
(30, 5, '10', 'GROS', 1, 1, '2023-01-18 11:34:26', '2023-01-18 11:34:26'),
(31, 7, '13', 'DETAIL', 1, 1, '2023-01-22 06:12:29', '2023-01-22 06:12:29'),
(32, 10, '12', 'DETAIL', 1, 8, '2023-01-26 08:18:14', '2023-01-26 08:18:14'),
(33, 10, '12', 'PROMOTIONNELLE', 1, 8, '2023-01-26 08:18:21', '2023-01-26 08:18:21'),
(34, 11, '12', 'DETAIL', 1, 8, '2023-01-27 13:44:13', '2023-01-27 13:44:13'),
(35, 12, '30.7', 'DETAIL', 1, 8, '2023-01-28 09:47:45', '2023-01-28 09:47:45'),
(36, 12, '23', 'GROS', 1, 8, '2023-01-28 12:44:08', '2023-01-28 12:44:08'),
(37, 12, '10.5', 'PROMOTIONNELLE', 1, 8, '2023-01-28 13:00:01', '2023-01-28 13:00:01'),
(38, 13, '1.7', 'DETAIL', 3, 11, '2023-01-29 02:32:39', '2023-01-29 02:32:39'),
(39, 13, '1.2', 'GROS', 3, 11, '2023-01-29 02:32:48', '2023-01-29 02:32:48'),
(40, 13, '1.1', 'ABONNEE', 3, 11, '2023-01-29 02:32:56', '2023-01-29 02:32:56'),
(41, 14, '1.3', 'DETAIL', 3, 11, '2023-01-29 02:36:11', '2023-01-29 02:36:11'),
(42, 16, '150', 'DETAIL', 1, 12, '2023-01-29 14:52:11', '2023-01-29 14:52:11'),
(43, 16, '200', 'GROS', 1, 12, '2023-01-29 14:52:45', '2023-01-29 14:52:45'),
(45, 20, '0.9', 'GROS', 3, 11, '2023-02-06 08:57:59', '2023-02-06 08:57:59'),
(46, 20, '1.2', 'DETAIL', 3, 11, '2023-02-06 08:58:27', '2023-02-06 08:58:27');

-- --------------------------------------------------------

--
-- Table structure for table `price_settings`
--

CREATE TABLE `price_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `price_settings`
--

INSERT INTO `price_settings` (`id`, `name`, `status`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 'DETAIL', 0, 1, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(2, 'GROS', 0, 1, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(3, 'ABONNEE', 0, 1, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(4, 'PROMOTIONNELLE', 0, 1, 8, '2023-01-27 02:28:01', '2023-01-27 02:28:01'),
(5, 'DETAIL', 0, 12, 9, '2023-01-27 04:00:50', '2023-01-27 04:00:50'),
(6, 'GROS', 0, 12, 9, '2023-01-27 04:00:50', '2023-01-27 04:00:50'),
(7, 'ABONNEE', 0, 12, 9, '2023-01-27 04:00:50', '2023-01-27 04:00:50'),
(8, 'PROMOTIONNELLE', 0, 12, 9, '2023-01-27 04:00:50', '2023-01-27 04:00:50'),
(17, 'DETAIL', 0, 3, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(18, 'GROS', 0, 3, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(19, 'ABONNEE', 0, 3, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(20, 'PROMOTIONNELLE', 0, 3, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(21, 'DETAIL', 0, 4, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(22, 'GROS', 0, 4, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(23, 'ABONNEE', 0, 4, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(24, 'PROMOTIONNELLE', 0, 4, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(25, 'DETAIL', 0, 5, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(26, 'GROS', 0, 5, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(27, 'ABONNEE', 0, 5, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(28, 'PROMOTIONNELLE', 0, 5, 11, '2023-01-29 02:05:34', '2023-01-29 02:05:34'),
(137, 'DETAIL', 0, 1, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(138, 'GROS', 0, 1, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(139, 'ABONNEE', 0, 1, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(140, 'PROMOTIONNELLE', 0, 1, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(141, 'DETAIL', 0, 3, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(142, 'GROS', 0, 3, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(143, 'ABONNEE', 0, 3, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(144, 'PROMOTIONNELLE', 0, 3, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(145, 'DETAIL', 0, 11, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(146, 'GROS', 0, 11, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(147, 'ABONNEE', 0, 11, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33'),
(148, 'PROMOTIONNELLE', 0, 11, 12, '2023-01-29 14:51:33', '2023-01-29 14:51:33');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_unit_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `product_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `security_stock` int(11) NOT NULL,
  `expiration_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `product_unit_id`, `category_id`, `product_price`, `product_image`, `barcode`, `security_stock`, `expiration_date`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 'Drosty', 3, 1, NULL, NULL, NULL, 0, NULL, 1, 1, '2023-01-06 13:36:01', '2023-01-06 13:36:01'),
(2, 'Hp-envy', 4, 5, NULL, NULL, NULL, 0, NULL, 1, 1, '2023-01-10 09:44:23', '2023-01-25 12:00:43'),
(3, 'Mac-books', 4, 5, NULL, NULL, NULL, 0, NULL, 1, 1, '2023-01-14 13:17:33', '2023-01-14 13:50:14'),
(4, 'Bigo2', 4, 5, NULL, NULL, NULL, 0, '2023-01-14', 1, 1, '2023-01-14 14:23:43', '2023-01-25 11:59:45'),
(6, 'Ignange', 5, 6, NULL, NULL, NULL, 0, '2023-01-15', 2, 1, '2023-01-15 15:02:11', '2023-01-15 15:02:11'),
(7, 'Energy', 4, 2, NULL, NULL, 'GDGDJG', 0, '2023-02-10', 1, 1, '2023-01-22 06:12:15', '2023-01-22 06:12:15'),
(8, 'Jus-afia', 4, 5, NULL, NULL, NULL, 0, NULL, 1, 1, '2023-01-25 11:47:45', '2023-01-25 11:47:45'),
(9, 'Djodjo', 4, 4, NULL, NULL, NULL, 0, '2023-01-25', 1, 1, '2023-01-25 12:01:05', '2023-01-25 12:01:05'),
(10, 'T-shirt', 6, 7, NULL, NULL, NULL, 0, NULL, 1, 8, '2023-01-26 06:37:58', '2023-01-26 06:37:58'),
(11, 'Chapeau', 6, 7, NULL, NULL, NULL, 0, NULL, 1, 8, '2023-01-26 06:38:10', '2023-01-26 06:38:10'),
(12, 'Drosty', 6, 7, NULL, NULL, NULL, 0, '2023-01-21', 1, 8, '2023-01-28 09:45:26', '2023-01-28 09:45:41'),
(13, 'Novidas', 8, 8, NULL, NULL, NULL, 7, '2023-01-29', 3, 11, '2023-01-29 01:40:53', '2023-02-03 06:19:06'),
(14, 'Jus-afia', 8, 9, NULL, NULL, NULL, 1, '2023-02-01', 3, 11, '2023-01-29 02:34:04', '2023-02-03 06:22:09'),
(16, 'Hp', 9, 10, NULL, NULL, 'HFH4F4KJK4KK4IO4UK', 0, '2023-01-18', 1, 12, '2023-01-29 14:46:44', '2023-01-29 14:46:44'),
(17, 'Alivo', 8, 8, NULL, NULL, NULL, 20, '2023-03-29', 3, 11, '2023-01-29 18:29:47', '2023-02-06 07:16:52'),
(19, 'Energy', 8, 9, NULL, NULL, NULL, 5, '2023-01-29', 3, 11, '2023-01-29 19:34:09', '2023-02-03 08:35:25'),
(20, 'Amidol', 10, 14, NULL, NULL, NULL, 0, '2023-02-09', 3, 11, '2023-02-06 08:54:07', '2023-02-06 08:55:22');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'SUPER-ADMIN', NULL, NULL),
(2, 'ADMIN', NULL, NULL),
(3, 'SUB-ADMIN', NULL, NULL),
(4, 'USER', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `selected_products`
--

CREATE TABLE `selected_products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `last_order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_qty` int(11) NOT NULL,
  `product_price` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_validated` int(11) NOT NULL,
  `print_type` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `selected_products`
--

INSERT INTO `selected_products` (`id`, `last_order_id`, `product_id`, `product_qty`, `product_price`, `is_validated`, `print_type`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, '12', 1, 0, 1, 1, '2023-01-10 09:43:12', '2023-01-10 10:07:33'),
(2, 1, 2, 1, '12', 1, 0, 1, 1, '2023-01-10 10:07:10', '2023-01-10 10:07:33'),
(3, 3, 1, 3, '12', 1, 0, 1, 1, '2023-01-18 07:34:16', '2023-01-19 06:49:43'),
(4, 3, 2, 1, '12', 1, 0, 1, 1, '2023-01-18 07:39:16', '2023-01-19 06:49:43'),
(5, 4, 1, 1, '12', 1, 0, 1, 1, '2023-01-19 06:53:45', '2023-01-19 07:24:26'),
(6, 4, 2, 1, '12', 1, 0, 1, 1, '2023-01-19 06:53:48', '2023-01-19 07:24:26'),
(7, 4, 3, 1, '13', 1, 0, 1, 1, '2023-01-19 06:53:52', '2023-01-19 07:24:26'),
(8, 5, 1, 1, '12', 1, 0, 1, 1, '2023-01-19 07:26:22', '2023-01-19 07:26:32'),
(9, 6, 1, 1, '12', 1, 0, 1, 1, '2023-01-19 13:51:03', '2023-01-19 13:51:24'),
(10, 6, 2, 1, '12', 1, 0, 1, 1, '2023-01-19 13:51:06', '2023-01-19 13:51:24'),
(11, 6, 3, 1, '13', 1, 0, 1, 1, '2023-01-19 13:51:09', '2023-01-19 13:51:24'),
(12, 7, 1, 1, '12', 1, 0, 1, 1, '2023-01-19 13:54:26', '2023-01-19 13:54:31'),
(13, 7, 2, 1, '10', 1, 0, 1, 1, '2023-01-19 13:54:27', '2023-01-19 13:54:31'),
(14, 8, 1, 2, '12', 1, 0, 1, 1, '2023-01-20 07:45:01', '2023-01-20 07:50:25'),
(15, 8, 2, 2, '12', 1, 0, 1, 1, '2023-01-20 07:45:03', '2023-01-20 07:50:25'),
(18, 8, 4, 10, '12', 1, 0, 1, 1, '2023-01-20 07:50:07', '2023-01-20 07:50:25'),
(19, 9, 1, 1, '12', 1, 0, 1, 1, '2023-01-20 07:54:39', '2023-01-20 07:55:11'),
(20, 9, 2, 1, '10', 1, 0, 1, 1, '2023-01-20 07:54:41', '2023-01-20 07:55:11'),
(21, 9, 4, 1, '13', 1, 0, 1, 1, '2023-01-20 07:54:43', '2023-01-20 07:55:11'),
(22, 10, 2, 2, '10', 1, 0, 1, 1, '2023-01-20 08:45:51', '2023-01-20 08:46:00'),
(23, 10, 1, 1, '12', 1, 0, 1, 1, '2023-01-20 08:45:55', '2023-01-20 08:46:00'),
(24, 12, 2, 1, '10', 1, 0, 1, 1, '2023-01-20 10:11:34', '2023-01-20 10:12:33'),
(25, 12, 3, 1, '13', 1, 0, 1, 1, '2023-01-20 10:12:12', '2023-01-20 10:12:33'),
(28, 14, 2, 2, '12', 1, 0, 1, 1, '2023-01-22 06:15:00', '2023-01-22 06:15:43'),
(29, 14, 3, 3, '13', 1, 0, 1, 1, '2023-01-22 06:15:02', '2023-01-22 06:15:43'),
(31, 15, 1, 1, '12', 1, 0, 1, 1, '2023-01-23 15:04:53', '2023-01-23 15:05:24'),
(32, 15, 4, 1, '13', 1, 0, 1, 1, '2023-01-23 15:06:33', '2023-01-25 09:08:25'),
(33, 16, 1, 1, '12', 1, 0, 1, 1, '2023-01-25 10:36:24', '2023-01-25 10:36:26'),
(34, 17, 1, 1, '12', 1, 0, 1, 1, '2023-01-25 10:38:05', '2023-01-25 10:38:07'),
(35, 18, 1, 1, '12', 1, 0, 1, 1, '2023-01-25 10:42:58', '2023-01-25 10:43:03'),
(36, 19, 1, 2, '12', 1, 0, 1, 1, '2023-01-25 10:45:43', '2023-01-25 10:46:06'),
(37, 20, 1, 1, '12', 1, 0, 1, 1, '2023-01-25 11:02:22', '2023-01-25 11:02:25'),
(38, 21, 1, 1, '12', 1, 0, 1, 1, '2023-01-25 11:03:58', '2023-01-25 11:04:00'),
(47, 27, 10, 1, '12', 1, 0, 1, 8, '2023-01-26 10:33:00', '2023-01-26 10:33:03'),
(48, 28, 10, 1, '12', 1, 0, 1, 8, '2023-01-26 11:44:56', '2023-01-26 11:44:59'),
(49, 29, 10, 1, '12', 1, 0, 1, 8, '2023-01-26 13:02:18', '2023-01-26 13:02:23'),
(50, 30, 10, 2, '12', 1, 0, 1, 8, '2023-01-27 04:03:17', '2023-01-27 04:03:27'),
(51, 31, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 03:28:40', '2023-01-28 03:28:49'),
(52, 31, 11, 1, '12', 1, 0, 1, 8, '2023-01-28 03:28:44', '2023-01-28 03:28:49'),
(53, 32, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 04:23:19', '2023-01-28 04:35:19'),
(54, 33, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 04:44:21', '2023-01-28 04:44:29'),
(55, 33, 11, 1, '12', 1, 0, 1, 8, '2023-01-28 04:44:27', '2023-01-28 04:44:29'),
(56, 34, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 04:45:37', '2023-01-28 04:45:42'),
(57, 35, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 04:51:30', '2023-01-28 04:51:34'),
(58, 36, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 09:43:29', '2023-01-28 09:43:34'),
(60, 35, 11, 5, '12', 1, 0, 1, 8, '2023-01-28 09:46:50', '2023-01-28 09:47:21'),
(61, 35, 12, 1, '31', 1, 0, 1, 8, '2023-01-28 09:48:49', '2023-01-28 09:58:07'),
(62, 37, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 10:39:06', '2023-01-28 10:39:08'),
(63, 38, 11, 1, '12', 1, 0, 1, 8, '2023-01-28 10:39:51', '2023-01-28 10:40:01'),
(64, 38, 12, 1, '31', 1, 0, 1, 8, '2023-01-28 10:39:56', '2023-01-28 10:40:01'),
(65, 39, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 10:41:51', '2023-01-28 10:41:54'),
(66, 40, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 12:43:25', '2023-01-28 12:43:29'),
(67, 41, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 12:47:19', '2023-01-28 13:11:11'),
(75, 41, 12, 1, '10.5', 1, 0, 1, 8, '2023-01-28 13:09:57', '2023-01-28 13:11:11'),
(76, 42, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 13:43:27', '2023-01-28 13:43:34'),
(77, 42, 12, 1, '10.5', 1, 0, 1, 8, '2023-01-28 13:43:32', '2023-01-28 13:43:34'),
(78, 43, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 13:45:36', '2023-01-28 13:45:42'),
(79, 43, 12, 1, '10.5', 1, 0, 1, 8, '2023-01-28 13:45:40', '2023-01-28 13:45:42'),
(80, 44, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 14:11:21', '2023-01-28 14:11:25'),
(81, 45, 10, 1, '12', 1, 0, 1, 8, '2023-01-28 14:23:14', '2023-01-28 14:23:20'),
(82, 46, 13, 1, '1.2', 1, 0, 3, 11, '2023-01-29 02:36:30', '2023-01-29 02:36:37'),
(83, 46, 14, 1, '1.3', 1, 0, 3, 11, '2023-01-29 02:36:34', '2023-01-29 02:36:37'),
(84, 47, 13, 1, '1.2', 1, 0, 3, 11, '2023-01-29 02:49:08', '2023-01-29 02:49:14'),
(85, 47, 14, 1, '1.3', 1, 0, 3, 11, '2023-01-29 02:49:10', '2023-01-29 02:49:14'),
(86, 48, 13, 1, '1.2', 1, 0, 3, 11, '2023-01-29 09:29:54', '2023-01-29 09:29:59'),
(87, 49, 13, 1, '1.2', 1, 0, 3, 11, '2023-01-29 09:31:11', '2023-01-29 09:31:16'),
(88, 49, 14, 1, '1.3', 1, 0, 3, 11, '2023-01-29 09:31:12', '2023-01-29 09:31:16'),
(90, 51, 16, 1, '150', 1, 0, 1, 12, '2023-01-29 14:59:45', '2023-01-29 15:00:48'),
(91, 51, 16, 1, '200', 1, 0, 1, 12, '2023-01-29 15:00:32', '2023-01-29 15:00:48'),
(92, 52, 13, 1, '1.2', 1, 0, 3, 11, '2023-01-29 19:41:12', '2023-01-29 19:41:14'),
(93, 53, 13, 1, '1.2', 1, 0, 3, 11, '2023-01-29 20:09:59', '2023-01-29 20:10:02'),
(94, 54, 20, 1, '0.9', 1, 0, 3, 11, '2023-02-06 08:58:53', '2023-02-06 08:59:18'),
(95, 54, 14, 2, '1.3', 1, 0, 3, 11, '2023-02-06 08:59:03', '2023-02-06 09:00:32'),
(96, 54, 14, 1, '1.3', 1, 0, 3, 11, '2023-02-06 09:00:26', '2023-02-06 09:00:32'),
(97, 55, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-06 09:11:25', '2023-02-06 09:11:36'),
(98, 55, 20, 2, '0.9', 1, 0, 3, 11, '2023-02-06 09:11:30', '2023-02-06 09:11:36'),
(99, 56, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-06 09:13:50', '2023-02-06 09:13:56'),
(100, 56, 20, 1, '1.2', 1, 0, 3, 11, '2023-02-06 09:13:53', '2023-02-06 09:13:56'),
(101, 57, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-07 03:37:50', '2023-02-07 03:37:54'),
(102, 57, 14, 1, '1.3', 1, 0, 3, 11, '2023-02-07 03:37:52', '2023-02-07 03:37:54'),
(103, 58, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-09 09:51:59', '2023-02-09 09:52:02'),
(104, 58, 14, 1, '1.3', 1, 0, 3, 11, '2023-02-09 09:52:00', '2023-02-09 09:52:02'),
(105, 59, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-09 10:47:50', '2023-02-09 10:47:52'),
(106, 60, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-10 05:06:21', '2023-02-10 05:06:27'),
(107, 60, 14, 1, '1.3', 1, 0, 3, 11, '2023-02-10 05:06:24', '2023-02-10 05:06:27'),
(108, 61, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-16 07:19:33', '2023-02-16 07:19:35'),
(109, 62, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-16 07:22:22', '2023-02-16 07:22:24'),
(110, 63, 13, 1, '1.2', 1, 0, 3, 11, '2023-02-20 04:50:36', '2023-02-20 04:50:40');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telephone` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_gain` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rate` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `name`, `email`, `telephone`, `customer_gain`, `vat`, `rate`, `logo`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(3, 'KIVU-BUS. TECH', 'kivu@gmail.com', '0990293', '0.005', '0', '2000', NULL, 3, 7, '2023-01-26 03:34:24', '2023-01-26 03:34:24'),
(4, 'YM', 'ym@gmail.com', '', '0', '0', '0', NULL, 5, 9, '2023-01-19 06:42:11', '2023-01-01 22:00:00'),
(5, 'NAP-BUSINESS', 'nap@gmail.com', '09916436', '0', '0', '2000', NULL, 1, 8, '2023-01-26 06:20:19', '2023-01-26 06:20:19'),
(6, 'NAP-BUSINESS', 'nap@gmail.com', '09916436', '0.05', 'USD', '2000', NULL, 1, 8, '2023-01-29 01:20:01', '2023-01-29 01:20:01'),
(7, 'Jordan-shop', 'jordan@gmail.com', '+243 886 677 876', '0.04', '0', '9', NULL, 3, 11, NULL, NULL),
(8, 'MARQUI', 'julien@gmail.com', '+243 99847', '0', '0', '0', NULL, 1, 12, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'IMPRIMERIE-01', NULL, NULL),
(2, 'IMPRIMERIE-02', NULL, NULL),
(3, 'SHOP-01', NULL, NULL),
(4, 'SHOP-02', NULL, NULL),
(5, 'SHOP-03', NULL, NULL),
(6, 'SHOP-04', NULL, NULL),
(7, 'SHOP-05', NULL, NULL),
(8, 'RESTAURANT', NULL, NULL),
(9, 'SUPERMARKET', NULL, NULL),
(10, 'BOITE DE NUIT', NULL, NULL),
(11, 'LOCATION-01', NULL, NULL),
(12, 'YM', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `spaces`
--

CREATE TABLE `spaces` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `spaces`
--

INSERT INTO `spaces` (`id`, `name`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 'Corridor', 1, 1, '2023-01-06 13:05:10', '2023-01-06 13:05:10'),
(2, 'Living-room01', 1, 1, '2023-01-06 13:05:32', '2023-01-06 13:05:32'),
(3, 'Living-room02', 1, 1, '2023-01-06 13:05:39', '2023-01-06 13:05:39'),
(4, 'Living-room03', 1, 1, '2023-01-06 13:05:47', '2023-01-06 13:05:47'),
(5, 'REC', 1, 8, '2023-01-26 08:31:43', '2023-01-26 08:31:43'),
(6, 'REC', 0, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `stock` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`id`, `product_id`, `stock`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 1, 9, 1, 1, '2023-01-06 13:36:01', '2023-01-25 11:41:29'),
(2, 2, 7, 1, 1, '2023-01-10 09:44:23', '2023-01-25 11:37:04'),
(3, 3, 0, 1, 1, '2023-01-14 13:17:33', '2023-01-22 06:15:43'),
(4, 4, 202, 1, 1, '2023-01-14 14:23:43', '2023-01-25 11:37:04'),
(5, 5, 8, 1, 1, '2023-01-14 14:27:21', '2023-01-22 06:09:56'),
(6, 6, 0, 2, 1, '2023-01-15 15:02:11', '2023-01-15 15:02:11'),
(7, 7, 1, 1, 1, '2023-01-22 06:12:15', '2023-01-25 11:31:39'),
(8, 8, 0, 1, 1, '2023-01-25 11:47:45', '2023-01-25 11:47:45'),
(9, 9, 0, 1, 1, '2023-01-25 12:01:05', '2023-01-25 12:01:05'),
(10, 10, 7, 1, 8, '2023-01-26 06:37:58', '2023-01-28 14:23:20'),
(11, 11, 1, 1, 8, '2023-01-26 06:38:10', '2023-01-28 10:40:01'),
(12, 12, 9, 1, 8, '2023-01-28 09:45:26', '2023-01-28 13:45:42'),
(13, 13, 11, 3, 11, '2023-01-29 01:40:53', '2023-02-20 04:50:40'),
(14, 14, 28, 3, 11, '2023-01-29 02:34:04', '2023-02-10 05:06:27'),
(15, 15, 0, 3, 11, '2023-01-29 02:35:32', '2023-01-29 02:35:32'),
(16, 16, 23, 1, 12, '2023-01-29 14:46:44', '2023-01-29 15:00:48'),
(17, 17, 12, 3, 11, '2023-01-29 18:29:47', '2023-01-29 19:31:29'),
(18, 19, 4, 3, 11, '2023-01-29 19:34:09', '2023-01-29 19:37:27'),
(19, 20, 14, 3, 11, '2023-02-06 08:54:07', '2023-02-06 09:13:56');

-- --------------------------------------------------------

--
-- Table structure for table `supply_stocks`
--

CREATE TABLE `supply_stocks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `provider_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider_telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_qty` int(11) NOT NULL,
  `total_price` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supply_stocks`
--

INSERT INTO `supply_stocks` (`id`, `product_id`, `provider_name`, `provider_telephone`, `product_price`, `product_qty`, `total_price`, `comment`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 1, 'Mungabo-shop', '0917827237', '7', 12, '84', 'Made in chine', 1, 1, '2023-01-06', '2023-01-06 13:57:52'),
(2, 2, NULL, NULL, NULL, 11, '0', NULL, 1, 1, '2023-01-10', '2023-01-10 09:46:14'),
(3, 3, NULL, NULL, NULL, 6, '0', NULL, 1, 1, '2023-01-19', '2023-01-19 06:54:33'),
(4, 4, NULL, NULL, NULL, 13, '0', NULL, 1, 1, '2023-01-20', '2023-01-20 07:45:23'),
(5, 4, 'kivu-tech', '09917382', '12', 200, '2400', NULL, 1, 1, '2023-01-20', '2023-01-20 07:45:46'),
(6, 4, NULL, NULL, NULL, 1, '0', NULL, 1, 1, '2023-01-20', '2023-01-20 07:45:56'),
(7, 1, NULL, NULL, NULL, 9, '0', NULL, 1, 1, '2023-01-22', '2023-01-22 06:06:29'),
(8, 2, NULL, NULL, NULL, 6, '0', NULL, 1, 1, '2023-01-22', '2023-01-22 06:06:33'),
(9, 2, NULL, NULL, NULL, 3, '0', NULL, 1, 1, '2023-01-22', '2023-01-22 06:09:01'),
(10, 5, NULL, NULL, NULL, 3, '0', NULL, 1, 1, '2023-01-22', '2023-01-22 06:09:05'),
(11, 5, 'jonny-shop', '099872837', '2', 5, '10', 'made in china', 1, 1, '2023-01-22', '2023-01-22 06:09:56'),
(12, 7, NULL, NULL, NULL, 2, '0', NULL, 1, 1, '2023-01-22', '2023-01-22 06:12:22'),
(13, 1, NULL, NULL, NULL, 5, '0', NULL, 1, 1, '2023-01-25', '2023-01-25 11:06:33'),
(14, 10, NULL, NULL, NULL, 14, '0', NULL, 1, 8, '2023-01-26', '2023-01-26 08:18:51'),
(15, 11, NULL, NULL, NULL, 4, '0', NULL, 1, 8, '2023-01-26', '2023-01-26 08:19:53'),
(16, 11, NULL, NULL, NULL, 6, '0', NULL, 1, 8, '2023-01-28', '2023-01-28 09:46:15'),
(17, 12, NULL, NULL, NULL, 9, '0', NULL, 1, 8, '2023-01-28', '2023-01-28 09:46:18'),
(18, 12, NULL, NULL, NULL, 5, '0', NULL, 1, 8, '2023-01-28', '2023-01-28 09:46:22'),
(19, 10, NULL, NULL, NULL, 12, '0', NULL, 1, 8, '2023-01-28', '2023-01-28 12:47:03'),
(20, 13, NULL, NULL, NULL, 14, '0', NULL, 3, 11, '2023-01-29', '2023-01-29 01:41:02'),
(21, 14, NULL, NULL, NULL, 10, '0', NULL, 3, 11, '2023-01-29', '2023-01-29 02:34:12'),
(22, 16, NULL, NULL, NULL, 10, '0', NULL, 1, 12, '2023-01-29', '2023-01-29 14:47:32'),
(23, 16, 'JHDJHDJHJHD', '4478784784', '100', 18, '1800', 'JHDHJDHJHD', 1, 12, '2023-01-29', '2023-01-29 14:53:43'),
(24, 13, NULL, NULL, NULL, 3, '0', NULL, 3, 11, '2023-01-29', '2023-01-29 19:14:27'),
(25, 13, 'JOSH', '0934873', '2', 12, '24.6', NULL, 3, 11, '2023-01-29', '2023-01-29 19:21:47'),
(26, 13, NULL, NULL, NULL, 1, '0', NULL, 3, 11, '2023-01-29', '2023-01-29 19:22:57'),
(27, 13, 'DOCTEUR', '03883', '4', 1, '4', NULL, 3, 11, '2023-01-29', '2023-01-29 19:29:39'),
(28, 17, 'bienfait', '0999384637', '10', 12, '120', NULL, 3, 11, '2023-01-29', '2023-01-29 19:31:29'),
(29, 19, 'BEN-HONG', '0938473', '3', 3, '9', NULL, 3, 11, '2023-01-29', '2023-01-29 19:37:06'),
(30, 19, 'KI', '093', '3', 1, '3', NULL, 3, 11, '2023-01-29', '2023-01-29 19:37:27'),
(31, 14, 'DIEUDO', '09383738', '3', 24, '72', 'MADE IN CHINA', 3, 11, '2023-01-31', '2023-01-31 12:10:47'),
(32, 20, NULL, NULL, NULL, 20, '0', NULL, 3, 11, '2023-02-06', '2023-02-06 08:54:44'),
(33, 14, NULL, NULL, NULL, 3, '0', NULL, 3, 11, '2023-02-06', '2023-02-06 09:21:00');

-- --------------------------------------------------------

--
-- Table structure for table `tables`
--

CREATE TABLE `tables` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `space_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tables`
--

INSERT INTO `tables` (`id`, `space_id`, `name`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 1, 'Table-01', 1, 1, '2023-01-06 13:05:59', '2023-01-06 13:05:59'),
(2, 1, 'Table-02', 1, 1, '2023-01-06 13:06:05', '2023-01-06 13:06:05'),
(3, 1, 'Table-03', 1, 1, '2023-01-06 13:06:16', '2023-01-06 13:06:16'),
(4, 2, 'Table-01', 1, 1, '2023-01-06 13:06:23', '2023-01-06 13:06:23'),
(5, 4, 'Table-01', 1, 1, '2023-01-06 13:06:30', '2023-01-06 13:06:30'),
(6, 4, 'Table-02', 1, 1, '2023-01-06 13:06:35', '2023-01-06 13:06:35'),
(7, 5, 'T-01', 1, 8, '2023-01-26 08:33:27', '2023-01-26 08:33:27'),
(8, 6, 'REC', 0, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ticketings`
--

CREATE TABLE `ticketings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `amount` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bill_number` int(11) NOT NULL,
  `currency` int(11) NOT NULL,
  `transaction_type` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticketings`
--

INSERT INTO `ticketings` (`id`, `amount`, `bill_number`, `currency`, `transaction_type`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, '10', 12, 1, 0, 1, 8, '2023-01-27', '2023-01-27 07:53:11'),
(2, '100', 3, 2, 0, 1, 8, '2023-01-27', '2023-01-27 07:53:31'),
(3, '10', 3, 1, 0, 1, 8, '2023-01-28', '2023-01-28 04:02:47'),
(5, '5', 2, 1, 0, 1, 12, '2023-01-29', '2023-01-29 15:10:03'),
(6, '6', 2, 1, 0, 1, 12, '2023-01-29', '2023-01-29 15:11:18'),
(7, '2', 6, 1, 0, 3, 11, '2023-02-09', '2023-02-09 10:51:43');

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `unit_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`id`, `unit_name`, `current_shop`, `host_customer_id`, `created_at`, `updated_at`) VALUES
(1, 'ML', 1, 1, '2023-01-06 13:29:05', '2023-01-06 13:29:05'),
(2, 'CL', 1, 1, '2023-01-06 13:30:04', '2023-01-06 13:30:04'),
(3, 'Liters', 1, 1, '2023-01-06 13:35:29', '2023-01-06 13:54:18'),
(4, 'Autres', 1, 1, '2023-01-10 09:44:02', '2023-01-10 09:44:02'),
(5, 'LITRE', 2, 1, '2023-01-15 15:01:44', '2023-01-15 15:01:44'),
(6, 'AUCUN', 1, 8, '2023-01-26 06:37:34', '2023-01-26 06:37:34'),
(7, 'Ltr', 3, 11, '2023-01-29 01:39:34', '2023-01-29 01:40:05'),
(8, 'mml', 3, 11, '2023-01-29 01:39:43', '2023-01-29 01:39:57'),
(9, 'AUCUN', 1, 12, '2023-01-29 14:45:00', '2023-01-29 14:45:00'),
(10, '250GRAM', 3, 11, '2023-02-06 08:50:27', '2023-02-06 08:50:27');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `app_level` int(11) NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `main_currency` int(11) DEFAULT NULL,
  `secondary_currency` int(11) NOT NULL,
  `current_shop` int(11) NOT NULL,
  `host_customer_id` int(11) NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `type`, `app_level`, `image`, `email_verified_at`, `password`, `main_currency`, `secondary_currency`, `current_shop`, `host_customer_id`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Bienfait-Ijambo', 'ijamboizuba20@gmail.com', 'SUPERUSER', 0, NULL, NULL, '$2y$10$tOCXxlhY/3HSlaIvlCgnROfYSQSPTy57e.eMqNn9Sq9Plg6jCYVb6', 1, 2, 12, 9, NULL, '2023-01-06 13:01:43', '2023-02-08 04:13:46'),
(5, 'DG-MUGABO-SHOP', 'mu@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$0pySf.CPRwc8DRDes5WqVOx5UuKOS9EQP90En3I8kWAJGuuOMT.bC', 1, 2, 3, 7, NULL, '2023-01-26 02:48:19', '2023-01-26 05:57:15'),
(6, 'DG', 'nap@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$wRvRqDqZo9ySx0EF7NfO4e5Oro8JjsIJksckubJegON8./k7wCYBG', 1, 2, 1, 8, NULL, '2023-01-26 06:17:14', '2023-01-29 01:17:02'),
(7, 'NADEGE', 'nadage@gmail.com', 'USER', 0, NULL, NULL, '$2y$10$/ucSZ74ZKFCOSLnfdhIfFOa0Id2ww3H3mxbQWG1rCkiEkK82YhPQO', 1, 2, 1, 8, NULL, '2023-01-26 06:25:15', '2023-01-26 07:27:35'),
(8, 'AUGUSTIN', 'agus0@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$Pe5yhtU.XFVNjcrd3GVDm.IY0Mk2D12BcSW0CVqJq4.TlXYh8A89K', 1, 2, 1, 8, NULL, '2023-01-26 06:33:00', '2023-01-26 06:33:00'),
(9, 'FISTON', 'fiston@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$lKPXGtI7qbzezCUWdoWn7u64BeD0VqdAqT87ROzNWSAZgMaTyrGny', 1, 2, 1, 8, NULL, '2023-01-26 06:33:29', '2023-01-26 06:33:29'),
(11, 'DG-JORDAN', 'jordan@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$zO5n/ByvtsXi1ZZ6KrnoYO2go.3DBXL3c34LHEh7rNGl7Xst7RBNW', 1, 2, 3, 11, NULL, '2023-01-29 01:29:08', '2023-01-29 09:28:12'),
(12, 'Nicole', 'nicole@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$FcA7.kN0CcZq6YMoTDO4yOCk8wgtYNteiLy4d3NADfNcLjMwhHbmC', 1, 2, 3, 11, NULL, '2023-01-29 02:40:04', '2023-02-20 05:01:51'),
(13, 'david', 'david0@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$ZIIGo6gBAipZS7MD5Z1lke5fEN2lt3hEYToIMVIXlSb1BX6OtjnV2', 1, 2, 3, 11, NULL, '2023-01-29 02:42:18', '2023-01-29 02:42:18'),
(14, 'Vianne', 'vianne@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$HEM9.LyiHZ2S3MgiB138XubxCRf3vGFSsuOQJZX17uwHLTt9nEELK', 1, 2, 3, 11, NULL, '2023-01-29 02:45:17', '2023-01-29 02:45:17'),
(15, 'Dorcas', 'dorisuba20@gmail.com', 'ADMIN', 0, NULL, NULL, '$2y$10$cOV39RU.f4waED9OT0ls0OO4jUuZcfu467blusiE9qRg7LRD4a8Sa', 1, 2, 3, 11, NULL, '2023-01-29 02:45:58', '2023-01-29 02:45:58'),
(16, 'JULIEN', 'julien@gmail.com', 'SUPERADMIN', 0, NULL, NULL, '$2y$10$gXz2UWI5pTn67Xoh.ifwnOz7g/FMstEMOdmDagvJE0qpwJqKuD71K', 1, 2, 1, 12, NULL, '2023-01-29 14:32:41', '2023-01-29 14:51:42'),
(17, 'JERMIE', 'jeere@gmail.com', 'ADMIN', 0, NULL, NULL, '$2y$10$o4N.FJIHToL.DJh70CuomezC8JO6TlTlCbsgP5cTpXOfzQaybbQlu', 1, 2, 3, 11, NULL, '2023-02-01 02:19:19', '2023-02-01 02:19:19');

-- --------------------------------------------------------

--
-- Table structure for table `user_actions`
--

CREATE TABLE `user_actions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_action_to_makes`
--

CREATE TABLE `user_action_to_makes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `action_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_page_to_acesses`
--

CREATE TABLE `user_page_to_acesses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_shop_to_acesses`
--

CREATE TABLE `user_shop_to_acesses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ym_customers`
--

CREATE TABLE `ym_customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_date` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `end_date` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `main_currency` int(11) NOT NULL,
  `secondary_currency` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ym_customers`
--

INSERT INTO `ym_customers` (`id`, `name`, `email`, `telephone`, `logo`, `start_date`, `end_date`, `main_currency`, `secondary_currency`, `created_at`, `updated_at`) VALUES
(1, 'Ubuntu', 'ubuntu@gmail.com', '+243 9938048', 'logo.PNG', '12/09/2022', '1/09/2022', 1, 2, NULL, NULL),
(3, 'KINSHOP', 'kinshop@gmail.com', '0938374837', NULL, '2023-01-10', '2023-01-18', 1, 2, NULL, NULL),
(4, 'KIVU-TECH', 'kivu23@gmail.com', '09967490', NULL, '2023-01-14', '2023-01-16', 1, 2, NULL, NULL),
(5, 'LA PAROLE', 'lap@gmail.com', '099383748', NULL, '2023-01-22', '2023-03-09', 1, 2, NULL, NULL),
(6, 'MGGL', 'mggl@gmail.com', '09987878', NULL, '2023-01-26', '2023-02-09', 2, 1, NULL, NULL),
(7, 'MUGABO', 'mugabo@gmail.com', '0494848549', NULL, '2023-01-26', '2023-02-11', 1, 2, NULL, NULL),
(8, 'NAP', 'nap@gmail.com', '03930', NULL, '2023-01-26', '2023-02-09', 1, 2, NULL, NULL),
(9, 'YM-BIENFAIT', 'ijambo@gmail.ccom', '0991653604', NULL, '', '', 1, 2, NULL, NULL),
(11, 'JORDAN-SHOP', 'jordan@gmail.com', '0909384', NULL, '2023-01-26', '2023-02-09', 1, 2, NULL, NULL),
(12, 'LE MARQUIE-SHOP', 'marqui@gmail.com', '094893834', NULL, '2023-01-29', '2023-02-11', 1, 2, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `app_client_pages`
--
ALTER TABLE `app_client_pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attrib_shops`
--
ALTER TABLE `attrib_shops`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `balances`
--
ALTER TABLE `balances`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `balance_histories`
--
ALTER TABLE `balance_histories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cash_histories`
--
ALTER TABLE `cash_histories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `code_ohadas`
--
ALTER TABLE `code_ohadas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currency_settings`
--
ALTER TABLE `currency_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_fidelities`
--
ALTER TABLE `customer_fidelities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `debt_balances`
--
ALTER TABLE `debt_balances`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `debt_payment_histories`
--
ALTER TABLE `debt_payment_histories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `out_product_qties`
--
ALTER TABLE `out_product_qties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `prices`
--
ALTER TABLE `prices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `price_settings`
--
ALTER TABLE `price_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `selected_products`
--
ALTER TABLE `selected_products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `spaces`
--
ALTER TABLE `spaces`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `supply_stocks`
--
ALTER TABLE `supply_stocks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ticketings`
--
ALTER TABLE `ticketings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `user_actions`
--
ALTER TABLE `user_actions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_action_to_makes`
--
ALTER TABLE `user_action_to_makes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_page_to_acesses`
--
ALTER TABLE `user_page_to_acesses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_shop_to_acesses`
--
ALTER TABLE `user_shop_to_acesses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ym_customers`
--
ALTER TABLE `ym_customers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `app_client_pages`
--
ALTER TABLE `app_client_pages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `attrib_shops`
--
ALTER TABLE `attrib_shops`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `balances`
--
ALTER TABLE `balances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=169;

--
-- AUTO_INCREMENT for table `balance_histories`
--
ALTER TABLE `balance_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `cash_histories`
--
ALTER TABLE `cash_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `code_ohadas`
--
ALTER TABLE `code_ohadas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `currency_settings`
--
ALTER TABLE `currency_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `customer_fidelities`
--
ALTER TABLE `customer_fidelities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `debt_balances`
--
ALTER TABLE `debt_balances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `debt_payment_histories`
--
ALTER TABLE `debt_payment_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `out_product_qties`
--
ALTER TABLE `out_product_qties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=180;

--
-- AUTO_INCREMENT for table `prices`
--
ALTER TABLE `prices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `price_settings`
--
ALTER TABLE `price_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `selected_products`
--
ALTER TABLE `selected_products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `shops`
--
ALTER TABLE `shops`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `spaces`
--
ALTER TABLE `spaces`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `supply_stocks`
--
ALTER TABLE `supply_stocks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `tables`
--
ALTER TABLE `tables`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `ticketings`
--
ALTER TABLE `ticketings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `user_actions`
--
ALTER TABLE `user_actions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_action_to_makes`
--
ALTER TABLE `user_action_to_makes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_page_to_acesses`
--
ALTER TABLE `user_page_to_acesses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_roles`
--
ALTER TABLE `user_roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_shop_to_acesses`
--
ALTER TABLE `user_shop_to_acesses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ym_customers`
--
ALTER TABLE `ym_customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
