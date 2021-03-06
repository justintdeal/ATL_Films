CREATE DATABASE IF NOT EXISTS `Team50`;
USE `Team50`;

DROP TABLE IF EXISTS `visit`;
DROP TABLE IF EXISTS `ccTransaction`;
DROP TABLE IF EXISTS `creditCard`;
DROP TABLE IF EXISTS `moviePlay`;
DROP TABLE IF EXISTS `movie`;
DROP TABLE IF EXISTS `theater`;
DROP TABLE IF EXISTS `manager`;
DROP TABLE IF EXISTS `admin`;
DROP TABLE IF EXISTS `employee`;
DROP TABLE IF EXISTS `customer`;
DROP TABLE IF EXISTS `company`;
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
    `username` varchar(50) NOT NULL,
    `password` varchar(50) NOT NULL,
    `status` ENUM('Pending','Approved','Declined') NOT NULL DEFAULT 'pending',
    `firstname` varchar(50) NOT NULL,
    `lastname` varchar(50) NOT NULL, 
    PRIMARY KEY (`username`)
) Engine=InnoDB;

CREATE TABLE `company` (
    `name` varchar(50) NOT NULL,
    PRIMARY KEY (`name`)
) ENGINE=InnoDB;

CREATE TABLE `customer` (
    `username` varchar(50) NOT NULL,
	PRIMARY KEY( `username`),
	CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`)
		ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE `employee` (
    `username` varchar(50) NOT NULL,
	PRIMARY KEY( `username`),
	CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`)
		ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE `admin` (
    `username` varchar(50) NOT NULL,
	PRIMARY KEY( `username`),
	CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`username`) REFERENCES `employee` (`username`)
		ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE `manager` (
    `username` varchar(50) NOT NULL,
    `company` varchar(50) NOT NULL,
    `street` varchar(50) NOT NULL,
    `city` varchar(50) NOT NULL,
    `state` char(2) NOT NULL,
    `zipcode` char(5) NOT NULL,
    PRIMARY KEY (`username`),
    UNIQUE (`street`,`city`,`state`,`zipcode`),
    CONSTRAINT `manager_ibfk_1` FOREIGN KEY (`username`) REFERENCES `employee` (`username`)
		ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `manager_ibfk_2` FOREIGN KEY (`company`) REFERENCES `company` (`name`)
		ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE `theater` ( 
    `company` varchar(50) NOT NULL,
    `name` varchar(50) NOT NULL,
    `street` varchar(50) NOT NULL,
    `city` varchar(50) NOT NULL,
    `state` char(2) NOT NULL,
    `zipcode` char(5) NOT NULL,
    `capacity` INT NOT NULL, 
    `manager` varchar(50) NOT NULL,
    PRIMARY KEY (`company`, `name`),
    CONSTRAINT `theater_ibfk_1` FOREIGN KEY (`company`) REFERENCES `company` (`name`)
		ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `theater_ibfk_2` FOREIGN KEY (`manager`) REFERENCES `manager` (`username`)
		ON DELETE RESTRICT ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE `movie` (
    `name` varchar(50) NOT NULL, 
    `release` date NOT NULL,
    `duration` INT NOT NULL,
    PRIMARY KEY (`name`, `release`)
) Engine = InnoDB;

CREATE TABLE `moviePlay` (
    `movie` varchar(50) NOT NULL,
    `releaseDate` date NOT NULL,
    `theater` varchar(50) NOT NULL, 
    `company` varchar(50) NOT NULL,
    `date` date NOT NULL,
    PRIMARY KEY (`movie`, `releaseDate`, `theater`, `company`, `date`),
    CONSTRAINT `moviePlay_ibfk_1` FOREIGN KEY (`movie`, `releaseDate`) REFERENCES `movie` (`name`, `release`)
		ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `moviePlay_ibfk_2` FOREIGN KEY (`company`, `theater`) REFERENCES `theater` (`company`,`name`)
		ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE `creditCard` (
    `creditCardNum` char(16) NOT NULL,
    `username` varchar(50) NOT NULL,
	PRIMARY KEY( `creditCardNum`),
	CONSTRAINT `creditCard_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`)
		ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE `ccTransaction` (
    `creditCardNum` char(16) NOT NULL,
    `movie` varchar(50) NOT NULL,
    `releaseDate` date NOT NULL,
    `theater` varchar(50) NOT NULL,
    `company` varchar(50) NOT NULL,
    `date` date NOT NULL,
    PRIMARY KEY (`creditCardNum`, `movie`, `releaseDate`, `theater`, `company`, `date`),
    CONSTRAINT `ccTransaction_ibfk_1` FOREIGN KEY (`movie`, `releaseDate`, `theater`, `company`, `date`) 
		REFERENCES `moviePlay` (`movie`, `releaseDate`, `theater`, `company`, `date`)
        ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT `ccTransaction_ibfk_2` FOREIGN KEY (`creditCardNum`) REFERENCES `creditCard` (`creditCardNum`)
		ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE `visit` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` varchar(50) NOT NULL,
    `theater` varchar(50) NOT NULL,
    `company` varchar(50) NOT NULL,
    `date` date NOT NULL,
	PRIMARY KEY(`id`),
	CONSTRAINT `visit_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`)
		ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `visit_ibfk_2` FOREIGN KEY (`company`, `theater`) REFERENCES `theater` (`company`,`name`) 
		ON DELETE RESTRICT ON UPDATE CASCADE
) Engine = InnoDB;