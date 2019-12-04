-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema library
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema library
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `library` DEFAULT CHARACTER SET utf8 ;
USE `library` ;

-- -----------------------------------------------------
-- Table `library`.`workers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`workers` (
  `worker_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`worker_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`books` (
  `isbn` VARCHAR(20) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`isbn`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`clients` (
  `client_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`client_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`inventory` (
  `book_id` INT NOT NULL AUTO_INCREMENT,
  `isbn` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`book_id`),
  INDEX `fk_inventory_books1_idx` (`isbn` ASC),
  CONSTRAINT `fk_inventory_books1`
    FOREIGN KEY (`isbn`)
    REFERENCES `library`.`books` (`isbn`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`taked_books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`taked_books` (
  `book_id` INT NOT NULL,
  `taked_date` DATETIME NOT NULL,
  `returned_date` DATETIME NULL,
  `time_limit` DATE NOT NULL,
  `worker_id` INT NOT NULL,
  `client_id` INT NOT NULL,
  INDEX `fk_taked_books_workers_idx` (`worker_id` ASC),
  INDEX `fk_taked_books_clients1_idx` (`client_id` ASC),
  INDEX `fk_taked_books_inventory1_idx` (`book_id` ASC),
  PRIMARY KEY (`book_id`),
  CONSTRAINT `fk_taked_books_workers`
    FOREIGN KEY (`worker_id`)
    REFERENCES `library`.`workers` (`worker_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_taked_books_clients`
    FOREIGN KEY (`client_id`)
    REFERENCES `library`.`clients` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_taked_books_inventory1`
    FOREIGN KEY (`book_id`)
    REFERENCES `library`.`inventory` (`book_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'books_book_id';


-- -----------------------------------------------------
-- Table `library`.`due_books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`due_books` (
  `worker_id` INT NOT NULL,
  `book_id` INT NOT NULL,
  `fine` DECIMAL(5,2) NULL,
  `date` DATETIME NULL,
  INDEX `fk_due_books_workers1_idx` (`worker_id` ASC),
  PRIMARY KEY (`worker_id`, `book_id`),
  INDEX `fk_due_books_taked_books1_idx` (`book_id` ASC),
  CONSTRAINT `fk_due_books_workers`
    FOREIGN KEY (`worker_id`)
    REFERENCES `library`.`workers` (`worker_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_due_books_taked_books1`
    FOREIGN KEY (`book_id`)
    REFERENCES `library`.`taked_books` (`book_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'fine';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
