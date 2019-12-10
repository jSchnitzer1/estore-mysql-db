SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `estore_report` ;

CREATE SCHEMA IF NOT EXISTS `estore_report` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `estore_report` ;

-- -----------------------------------------------------
-- estore_report tables
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `estore_report`.`general_analysis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore_report`.`general_analysis` (
  `id` INTEGER UNSIGNED AUTO_INCREMENT NOT NULL,
  `max_sold_product` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL,
  `min_sold_product` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL,
  `total_revenue` FLOAT NULL,
  `total_number_orders` INTEGER UNSIGNED NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore_report`.`user_analysis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore_report`.`user_analysis` (
  `id` INTEGER UNSIGNED AUTO_INCREMENT NOT NULL,
  `user_id`  INTEGER UNSIGNED NOT NULL,
  `full_name` VARCHAR(50) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'  NOT NULL,
  `total_number_orders` INTEGER UNSIGNED NULL,
  `total_spent` FLOAT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore_report`.`user_order_analysis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore_report`.`user_order_analysis` (
  `id` INTEGER UNSIGNED AUTO_INCREMENT NOT NULL,
  `user_id`  INTEGER UNSIGNED NOT NULL,
  `order_id`  INTEGER UNSIGNED NOT NULL,
  `full_name` VARCHAR(50) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'  NOT NULL,
  `total_spent_per_order` INTEGER UNSIGNED NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore_report`.`product_analysis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore_report`.`product_analysis` (
  `id` INTEGER UNSIGNED AUTO_INCREMENT NOT NULL,
  `product_id`  INTEGER UNSIGNED NOT NULL,
  `product_name` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `total_sold_per_product` INTEGER UNSIGNED NULL,
  `total_revenue_per_product` FLOAT NULL,
  `min_sold_product` INTEGER UNSIGNED NULL,
  `max_sold_product` INTEGER UNSIGNED NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
