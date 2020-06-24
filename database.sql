-- MySQL Script generated by MySQL Workbench
-- Wed Jun 24 13:40:28 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `userID` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(10) NOT NULL,
  `firstName` VARCHAR(30) NOT NULL,
  `lastName` VARCHAR(30) NOT NULL,
  `address` VARCHAR(100) NULL,
  `phoneNumber` INT(12) NOT NULL,
  `email` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE INDEX `userID_UNIQUE` (`userID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PassType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PassType` (
  `passTypeID` INT NOT NULL AUTO_INCREMENT,
  `passType` VARCHAR(20) NOT NULL,
  `PriceList_priceListID` INT NOT NULL,
  PRIMARY KEY (`passTypeID`, `PriceList_priceListID`),
  UNIQUE INDEX `passTypeID_UNIQUE` (`passTypeID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PriceList`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PriceList` (
  `priceListID` INT NOT NULL AUTO_INCREMENT,
  `price` FLOAT NOT NULL,
  `startDate` DATETIME NOT NULL,
  `endDate` DATETIME NULL,
  `PassType_passTypeID` INT NOT NULL,
  PRIMARY KEY (`priceListID`, `PassType_passTypeID`),
  UNIQUE INDEX `priceListID_UNIQUE` (`priceListID` ASC) VISIBLE,
  INDEX `fk_PriceList_PassType1_idx` (`PassType_passTypeID` ASC) VISIBLE,
  CONSTRAINT `fk_PriceList_PassType1`
    FOREIGN KEY (`PassType_passTypeID`)
    REFERENCES `mydb`.`PassType` (`passTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SkiPass`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SkiPass` (
  `skiPassID` INT NOT NULL AUTO_INCREMENT,
  `startDate` DATETIME NOT NULL,
  `expiryDate` DATETIME NOT NULL,
  `User_userID` INT NOT NULL,
  `PassType_passTypeID` INT NOT NULL,
  `PassType_PriceList_priceListID` INT NOT NULL,
  PRIMARY KEY (`skiPassID`, `User_userID`, `PassType_passTypeID`, `PassType_PriceList_priceListID`),
  UNIQUE INDEX `skiPassID_UNIQUE` (`skiPassID` ASC) VISIBLE,
  INDEX `fk_SkiPass_User1_idx` (`User_userID` ASC) VISIBLE,
  INDEX `fk_SkiPass_PassType1_idx` (`PassType_passTypeID` ASC, `PassType_PriceList_priceListID` ASC) VISIBLE,
  CONSTRAINT `fk_SkiPass_User1`
    FOREIGN KEY (`User_userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_SkiPass_PassType1`
    FOREIGN KEY (`PassType_passTypeID` , `PassType_PriceList_priceListID`)
    REFERENCES `mydb`.`PassType` (`passTypeID` , `PriceList_priceListID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SkiLift`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SkiLift` (
  `skiLiftID` INT NOT NULL AUTO_INCREMENT,
  `liftName` VARCHAR(20) NOT NULL,
  `liftLength` FLOAT NULL,
  `liftHeight` FLOAT NULL,
  `availability` TINYINT NULL,
  PRIMARY KEY (`skiLiftID`),
  UNIQUE INDEX `skiLiftID_UNIQUE` (`skiLiftID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SkiLiftUsage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SkiLiftUsage` (
  `skiLiftUsageID` INT NOT NULL,
  `timesUsed` INT NULL DEFAULT 0,
  `firstTimeUsed` DATETIME NOT NULL,
  `lastTimeUsed` DATETIME NOT NULL,
  `SkiLift_skiLiftID` INT NOT NULL,
  `SkiPass_skiPassID` INT NOT NULL,
  PRIMARY KEY (`skiLiftUsageID`, `SkiLift_skiLiftID`, `SkiPass_skiPassID`),
  UNIQUE INDEX `skiLiftUsageID_UNIQUE` (`skiLiftUsageID` ASC) VISIBLE,
  INDEX `fk_SkiLiftUsage_SkiLift1_idx` (`SkiLift_skiLiftID` ASC) VISIBLE,
  INDEX `fk_SkiLiftUsage_SkiPass1_idx` (`SkiPass_skiPassID` ASC) VISIBLE,
  CONSTRAINT `fk_SkiLiftUsage_SkiLift1`
    FOREIGN KEY (`SkiLift_skiLiftID`)
    REFERENCES `mydb`.`SkiLift` (`skiLiftID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SkiLiftUsage_SkiPass1`
    FOREIGN KEY (`SkiPass_skiPassID`)
    REFERENCES `mydb`.`SkiPass` (`skiPassID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Payment` (
  `paymentID` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `paymentMethod` VARCHAR(20) NULL,
  `SkiPass_skiPassID` INT NOT NULL,
  `SkiPass_User_userID` INT NOT NULL,
  `SkiPass_PassType_passTypeID` INT NOT NULL,
  `SkiPass_PassType_PriceList_priceListID` INT NOT NULL,
  PRIMARY KEY (`paymentID`, `SkiPass_skiPassID`, `SkiPass_User_userID`, `SkiPass_PassType_passTypeID`, `SkiPass_PassType_PriceList_priceListID`),
  UNIQUE INDEX `paymentID_UNIQUE` (`paymentID` ASC) VISIBLE,
  INDEX `fk_Payment_SkiPass1_idx` (`SkiPass_skiPassID` ASC, `SkiPass_User_userID` ASC, `SkiPass_PassType_passTypeID` ASC, `SkiPass_PassType_PriceList_priceListID` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_SkiPass1`
    FOREIGN KEY (`SkiPass_skiPassID` , `SkiPass_User_userID` , `SkiPass_PassType_passTypeID` , `SkiPass_PassType_PriceList_priceListID`)
    REFERENCES `mydb`.`SkiPass` (`skiPassID` , `User_userID` , `PassType_passTypeID` , `PassType_PriceList_priceListID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`LiftHistory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LiftHistory` (
  `liftHistoryID` INT NOT NULL AUTO_INCREMENT,
  `openingDate` DATETIME NOT NULL,
  `closingDate` DATETIME NULL,
  `timesUsed` INT NULL,
  `SkiLift_skiLiftID` INT NOT NULL,
  PRIMARY KEY (`liftHistoryID`, `SkiLift_skiLiftID`),
  UNIQUE INDEX `liftHistoryID_UNIQUE` (`liftHistoryID` ASC) VISIBLE,
  INDEX `fk_LiftHistory_SkiLift1_idx` (`SkiLift_skiLiftID` ASC) VISIBLE,
  CONSTRAINT `fk_LiftHistory_SkiLift1`
    FOREIGN KEY (`SkiLift_skiLiftID`)
    REFERENCES `mydb`.`SkiLift` (`skiLiftID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;