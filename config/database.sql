-- Adminer 4.2.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+03:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE `sysinfo` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `sysinfo`;

CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logs_id` int(11) NOT NULL,
  `name` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `logs_id` (`logs_id`),
  CONSTRAINT `params_ibfk_1` FOREIGN KEY (`logs_id`) REFERENCES `logs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `params_id` int(11) NOT NULL,
  `name` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `params_id` (`params_id`),
  CONSTRAINT `values_ibfk_1` FOREIGN KEY (`params_id`) REFERENCES `params` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

