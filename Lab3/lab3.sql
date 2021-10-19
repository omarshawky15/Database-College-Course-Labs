-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema SAMPLE43
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema SAMPLE43
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `SAMPLE43` DEFAULT CHARACTER SET utf8 ;
USE `SAMPLE43` ;

-- -----------------------------------------------------
-- Table `SAMPLE43`.`Publisher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAMPLE43`.`Publisher` (
  `Name` VARCHAR(255) NOT NULL,
  `Address` VARCHAR(255) NULL,
  `Phone` INT NULL,
  PRIMARY KEY (`Name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAMPLE43`.`Book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAMPLE43`.`Book` (
  `BookId` INT NOT NULL,
  `Title` VARCHAR(255) NULL,
  `PublisherName` VARCHAR(255) NULL,
  PRIMARY KEY (`BookId`),
  INDEX `PublisherName_idx` (`PublisherName` ASC) VISIBLE,
  CONSTRAINT `BPublisherName`
    FOREIGN KEY (`PublisherName`)
    REFERENCES `SAMPLE43`.`Publisher` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAMPLE43`.`BookAuthors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAMPLE43`.`BookAuthors` (
  `BookId` INT NOT NULL,
  `AuthorName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`BookId`, `AuthorName`),
  CONSTRAINT `BABookId`
    FOREIGN KEY (`BookId`)
    REFERENCES `SAMPLE43`.`Book` (`BookId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAMPLE43`.`Library_Branch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAMPLE43`.`Library_Branch` (
  `BranchId` INT NOT NULL,
  `BranchName` VARCHAR(255) NULL,
  `Address` VARCHAR(255) NULL,
  PRIMARY KEY (`BranchId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAMPLE43`.`Book_Copies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAMPLE43`.`Book_Copies` (
  `BookId` INT NOT NULL,
  `BranchId` INT NOT NULL,
  `No_Of_Copies` INT NULL,
  PRIMARY KEY (`BookId`, `BranchId`),
  INDEX `BranchId_idx` (`BranchId` ASC) VISIBLE,
  CONSTRAINT `BCBookId`
    FOREIGN KEY (`BookId`)
    REFERENCES `SAMPLE43`.`Book` (`BookId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `BCBranchId`
    FOREIGN KEY (`BranchId`)
    REFERENCES `SAMPLE43`.`Library_Branch` (`BranchId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAMPLE43`.`Borrower`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAMPLE43`.`Borrower` (
  `CardNo` INT NOT NULL,
  `Name` VARCHAR(255) NULL,
  `Address` VARCHAR(255) NULL,
  `Phone` VARCHAR(255) NULL,
  PRIMARY KEY (`CardNo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAMPLE43`.`Book_Loans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAMPLE43`.`Book_Loans` (
  `BookId` INT NOT NULL,
  `CardId` INT NOT NULL,
  `BranchId` INT NOT NULL,
  `DateOut` DATE NULL,
  `DueDate` DATE NULL,
  PRIMARY KEY (`BookId`, `CardId`, `BranchId`),
  INDEX `BLCardId_idx` (`CardId` ASC) VISIBLE,
  INDEX `BLBranchId_idx` (`BranchId` ASC) VISIBLE,
  CONSTRAINT `BLCardId`
    FOREIGN KEY (`CardId`)
    REFERENCES `SAMPLE43`.`Borrower` (`CardNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `BLBranchId`
    FOREIGN KEY (`BranchId`)
    REFERENCES `SAMPLE43`.`Library_Branch` (`BranchId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `BLBookId`
    FOREIGN KEY (`BookId`)
    REFERENCES `SAMPLE43`.`Book` (`BookId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
