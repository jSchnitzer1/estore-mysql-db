SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `estore` ;

CREATE SCHEMA IF NOT EXISTS `estore` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `estore` ;

-- -----------------------------------------------------
-- estore tables
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `estore`.`order_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`order_status` (
  `id` INTEGER UNSIGNED NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`role` (
  `id` INTEGER UNSIGNED NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`customer` (
  `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `password` VARCHAR(200) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `firstname` VARCHAR(20) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `lastname` VARCHAR(20) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `phone` VARCHAR(45) NULL,
  `address` TEXT NULL,
  `role_id` INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_customer_role1_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `fk_customer_role1_idx`
    FOREIGN KEY (`role_id`)
    REFERENCES `estore`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`order` (
  `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `amount` FLOAT NOT NULL,
  `shipAddress` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tracking_number` VARCHAR(80) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL DEFAULT NULL,
  `order_status_id` INTEGER UNSIGNED NOT NULL,
  `customer_id` INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_order_order_status1_idx` (`order_status_id` ASC) VISIBLE,
  INDEX `fk_order_customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_order_status1_idx`
    FOREIGN KEY (`order_status_id`)
    REFERENCES `estore`.`order_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_customer1_idx`
    FOREIGN KEY (`customer_id`)
    REFERENCES `estore`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`product_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`product_category` (
  `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `description` TEXT CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`product` (
  `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `sku` VARCHAR(50) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `name` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `price` FLOAT NOT NULL,
  `quantity` INT NOT NULL,
  `description` TEXT NULL,
  `thumb_path` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL,
  `image_path` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL,
  `product_category_id` INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_product_product_category1_idx` (`product_category_id` ASC) VISIBLE,
  CONSTRAINT `fk_product_product_category1_idx`
    FOREIGN KEY (`product_category_id`)
    REFERENCES `estore`.`product_category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`order_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`order_product` (
  `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INTEGER UNSIGNED NOT NULL,
  `product_id` INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_order_product_order1_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_order_product_product1_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_product_order1_idx`
    FOREIGN KEY (`order_id`)
    REFERENCES `estore`.`order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_product_product1_idx`
    FOREIGN KEY (`product_id`)
    REFERENCES `estore`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- estore audit tables
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `estore`.`product_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`product_audit` (
  `audit_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` INTEGER UNSIGNED NOT NULL,
  `operation` CHAR(1) NOT NULL,
  `transdate` DATETIME NOT NULL,
  `user` VARCHAR(30) NOT NULL,
  `sku` VARCHAR(50) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `name` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `price` FLOAT NOT NULL,
  `quantity` INT NOT NULL,
  `description` TEXT NULL,
  `thumb_path` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL,
  `image_path` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL,
  `product_category_id` INT NOT NULL,
  PRIMARY KEY (`audit_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`product_category_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`product_category_audit` (
  `audit_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` INTEGER UNSIGNED NOT NULL,
  `operation` CHAR(1) NOT NULL,
  `transdate` DATETIME NOT NULL,
  `user` VARCHAR(30) NOT NULL,
  `name` VARCHAR(50) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `description` TEXT CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL,
  PRIMARY KEY (`audit_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`order_product_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`order_product_audit` (
  `audit_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` INTEGER UNSIGNED NOT NULL,
  `operation` CHAR(1) NOT NULL,
  `transdate` DATETIME NOT NULL,
  `user` VARCHAR(30) NOT NULL,
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`audit_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`order_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`order_audit` (
  `audit_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` INTEGER UNSIGNED NOT NULL,
  `operation` CHAR(1) NOT NULL,
  `transdate` DATETIME NOT NULL,
  `user` VARCHAR(30) NOT NULL,
  `amount` FLOAT NOT NULL,
  `shipAddress` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tracking_number` VARCHAR(80) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL DEFAULT NULL,
  `order_status_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`audit_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`customer_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`customer_audit` (
  `audit_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` INTEGER UNSIGNED NOT NULL,
  `operation` CHAR(1) NOT NULL,
  `transdate` DATETIME NOT NULL,
  `user` VARCHAR(30) NOT NULL,
  `email` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `password` VARCHAR(200) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `firstname` VARCHAR(20) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `lastname` VARCHAR(20) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `phone` VARCHAR(45) NULL,
  `address` TEXT NULL,
  `role_id` INT NOT NULL,
  PRIMARY KEY (`audit_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`order_status_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`order_status_audit` (
  `audit_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` INTEGER UNSIGNED NOT NULL,
  `operation` CHAR(1) NOT NULL,
  `transdate` DATETIME NOT NULL,
  `user` VARCHAR(30) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`audit_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`role_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`role_audit` (
  `audit_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` INTEGER UNSIGNED NOT NULL,
  `operation` CHAR(1) NOT NULL,
  `transdate` DATETIME NOT NULL,
  `user` VARCHAR(30) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`audit_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tables Triggers
-- -----------------------------------------------------

SET @username := CURRENT_USER();

DELIMITER $$

-- -----------------------------------------------------
-- Triggers for table: product
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER product_audit_insert
BEFORE INSERT
ON product
FOR EACH ROW
BEGIN
  INSERT INTO product_audit (`id`, `operation`, `transdate`, `user`, `sku`, `name`, `price`, `quantity`, `description`, `thumb_path`, `image_path`, `product_category_id`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.SKU, NEW.NAME, NEW.PRICE, NEW.QUANTITY, NEW.DESCRIPTION, NEW.THUMB_PATH, NEW.IMAGE_PATH, NEW.PRODUCT_CATEGORY_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER product_audit_update
BEFORE UPDATE
ON product
FOR EACH ROW
BEGIN
  IF NEW.QUANTITY != OLD.QUANTITY OR NEW.PRICE != OLD.PRICE THEN
	INSERT INTO product_audit (`id`, `operation`, `transdate`, `user`, `sku`, `name`, `price`, `quantity`, `description`, `thumb_path`, `image_path`, `product_category_id`)
	VALUES (NEW.ID, 'U', NOW(), @username, NEW.SKU, NEW.NAME, NEW.PRICE, NEW.QUANTITY, NEW.DESCRIPTION, NEW.THUMB_PATH, NEW.IMAGE_PATH, NEW.PRODUCT_CATEGORY_ID);
  END IF;
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER product_aud_delete
BEFORE DELETE
ON product
FOR EACH ROW
BEGIN
	INSERT INTO product_audit (`id`, `operation`, `transdate`, `user`, `sku`, `name`, `price`, `quantity`, `description`, `thumb_path`, `image_path`, `product_category_id`)
	VALUES (OLD.ID, 'U', NOW(), @username, OLD.SKU, OLD.NAME, OLD.PRICE, OLD.QUANTITY, OLD.DESCRIPTION, OLD.THUMB_PATH, OLD.IMAGE_PATH, OLD.PRODUCT_CATEGORY_ID);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: role
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER role_audit_insert
BEFORE INSERT
ON `role`
FOR EACH ROW
BEGIN
  INSERT INTO role_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.TYPE, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER role_audit_update
BEFORE UPDATE
ON `role`
FOR EACH ROW
BEGIN
	INSERT INTO role_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
	VALUES (NEW.ID, 'U', NOW(), @username, NEW.TYPE, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER role_aud_delete
BEFORE DELETE
ON `role`
FOR EACH ROW
BEGIN
  INSERT INTO role_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
  VALUES (OLD.ID, 'D', NOW(), @username, OLD.TYPE, OLD.DESCRIPTION);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: customer
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER customer_audit_insert
BEFORE INSERT
ON `customer`
FOR EACH ROW
BEGIN
  INSERT INTO customer_audit (`id`, `operation`, `transdate`, `user`, `email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.EMAIL, NEW.PASSWORD, NEW.FIRSTNAME, NEW.LASTNAME, NEW.PHONE, NEW.ADDRESS, NEW.ROLE_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER customer_audit_update
BEFORE UPDATE
ON `customer`
FOR EACH ROW
BEGIN
	INSERT INTO customer_audit (`id`, `operation`, `transdate`, `user`, `email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`)
	VALUES (NEW.ID, 'U', NOW(), @username, NEW.EMAIL, NEW.PASSWORD, NEW.FIRSTNAME, NEW.LASTNAME, NEW.PHONE, NEW.ADDRESS, NEW.ROLE_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER customer_aud_delete
BEFORE DELETE
ON `customer`
FOR EACH ROW
BEGIN
	INSERT INTO customer_audit (`id`, `operation`, `transdate`, `user`, `email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`)
	VALUES (OLD.ID, 'U', NOW(), @username, OLD.EMAIL, OLD.PASSWORD, OLD.FIRSTNAME, OLD.LASTNAME, OLD.PHONE, OLD.ADDRESS, OLD.ROLE_ID);
END;
$$

-- -----------------------------------------------------
-- Insert some rows
-- -----------------------------------------------------
INSERT INTO `estore`.`role` (`id`, `type`, `description`) VALUES (1, 'admin', 'admin user');
INSERT INTO `estore`.`role` (`id`, `type`) VALUES (2, 'user');

INSERT INTO `estore`.`customer` (`email`, `password`, `firstname`, `lastname`, `role_id`) VALUES ('john1@myestore.com', '1211111w1w12dwsfdqsfawgfas`fafgvaszdfa', 'John', 'Grag', '1');
INSERT INTO `estore`.`customer` (`email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`) VALUES ('sandeep@gmail.com', '1234', 'Sandeep', 'Guta', '071234567', 'Kungstragården 51 12345 Stockholm', '2');
INSERT INTO `estore`.`customer` (`email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`) VALUES ('tommy@gmail.com', '5678', 'Tom', 'Campis', '079876542', 'Drotningsgatan 29 12345 Stockholm', '2');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
