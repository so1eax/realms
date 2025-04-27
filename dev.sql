-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 27, 2025 at 04:17 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dev`
--

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `id` int(11) NOT NULL,
  `license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `uid` int(11) NOT NULL,
  `reason` char(255) DEFAULT NULL,
  `author` char(255) DEFAULT NULL,
  `license2` varchar(255) DEFAULT NULL,
  `steam` varchar(255) DEFAULT NULL,
  `discord` varchar(255) DEFAULT NULL,
  `xbl` varchar(255) DEFAULT NULL,
  `live` varchar(255) DEFAULT NULL,
  `fivem` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bans`
--

INSERT INTO `bans` (`id`, `license`, `uid`, `reason`, `author`, `license2`, `steam`, `discord`, `xbl`, `live`, `fivem`, `ip`) VALUES
(1, 'license:64c899c3fd0d3dcd7479aed30fd1c0f3e4011477', 0, 'No reason specified', 'aydigga', 'license2:64c899c3fd0d3dcd7479aed30fd1c0f3e4011477', NULL, 'discord:1144070624692666439', NULL, NULL, NULL, 'ip:172.20.10.2');

-- --------------------------------------------------------

--
-- Table structure for table `outfits`
--

CREATE TABLE `outfits` (
  `id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `name` longtext DEFAULT NULL,
  `ped` longtext DEFAULT NULL,
  `components` longtext DEFAULT NULL,
  `props` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `prename` char(20) NOT NULL,
  `name` char(20) NOT NULL,
  `dob` date NOT NULL,
  `height` int(5) NOT NULL,
  `health` int(5) DEFAULT 200,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`coords`)),
  `appearance` longtext DEFAULT NULL,
  `cash` int(11) NOT NULL DEFAULT 0,
  `bank` int(11) NOT NULL DEFAULT 0,
  `items` longtext DEFAULT NULL,
  `admrk` char(10) NOT NULL DEFAULT 'user',
  `wipe` tinyint(1) NOT NULL DEFAULT 0,
  `job` char(25) NOT NULL DEFAULT 'unemployed',
  `crew` char(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `identifier`, `prename`, `name`, `dob`, `height`, `health`, `coords`, `appearance`, `cash`, `bank`, `items`, `admrk`, `wipe`, `job`, `crew`) VALUES
(0, 'license:64c899c3fd0d3dcd7479aed30fd1c0f3e4011477', '', 'aaaa', '1999-01-01', 199, 200, '{\"z\":56.071044921875,\"y\":2828.993408203125,\"x\":-338.05712890625}', NULL, 0, 0, NULL, 'user', 0, '', 'so1eax');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outfits`
--
ALTER TABLE `outfits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `identifier` (`identifier`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `outfits`
--
ALTER TABLE `outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
