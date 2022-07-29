-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 13, 2021 at 12:43 PM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_fat`
--

-- --------------------------------------------------------

--
-- Table structure for table `fat_data_tables`
--

CREATE TABLE `fat_data_tables` (
  `fat_name` varchar(100) NOT NULL,
  `latitude` varchar(100) NOT NULL,
  `longitude` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `fat_data_tables`
--

INSERT INTO `fat_data_tables` (`fat_name`, `latitude`, `longitude`) VALUES
('FAT-1', '3.5919887760', '98.700195821'),
('FAT-2', '3.5871340061', '98.700931002'),
('FAT-3', '3.5537769470', '98.658039501'),
('FAT-4', '3.5828656242', '98.698153770'),
('FAT-5', '3.6138', '98.6491'),
('FAT-6', '3.6141', '98.6448'),
('FAT-7', '3.6134', '98.6505'),
('FAT-8', '3.5914', '98.5653'),
('FAT-9', '3.6128', '98.648'),
('FAT-10', '3.6013', '98.597'),
('FAT-11', '3.5622', '98.6066'),
('FAT-12', '3.5895', '98.6333'),
('FAT-13', '3.5884', '98.6258'),
('FAT-14', '3.6011', '98.5976'),
('FAT-15', '3.5581', '98.594'),
('FAT-16', '3.5959', '98.6162'),
('FAT-17', '3.6126', '98.5803'),
('FAT-18', '3.5896', '98.5598'),
('FAT-19', '3.6344', '98.6641'),
('FAT-20', '3.5772', '98.6437'),
('FAT-21', '3.5844', '98.6201'),
('FAT-22', '3.6203', '98.5999'),
('FAT-23', '3.6319', '98.6641'),
('FAT-24', '3.5536', '98.6371'),
('FAT-25', '3.6033', '98.6236'),
('FAT-26', '3.5828', '98.6004'),
('FAT-27', '3.6057', '98.6135'),
('FAT-28', '3.5561', '98.6214'),
('FAT-29', '3.6349', '98.6661'),
('FAT-30', '3.5273', '98.6623');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
