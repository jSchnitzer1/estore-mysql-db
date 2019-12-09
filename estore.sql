SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET SQL_SAFE_UPDATES = 0;

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
  `type` VARCHAR(45) UNIQUE NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`role` (
  `id` INTEGER UNSIGNED NOT NULL,
  `type` VARCHAR(45) UNIQUE NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`user` (
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
  INDEX `fk_user_role1_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_role1_idx`
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
  `ship_address` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tracking_number` VARCHAR(80) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL DEFAULT NULL,
  `order_status_id` INTEGER UNSIGNED NOT NULL,
  `user_id` INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_order_order_status1_idx` (`order_status_id` ASC) VISIBLE,
  INDEX `fk_order_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_order_status1_idx`
    FOREIGN KEY (`order_status_id`)
    REFERENCES `estore`.`order_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_user1_idx`
    FOREIGN KEY (`user_id`)
    REFERENCES `estore`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`product_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`product_category` (
  `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' UNIQUE NOT NULL,
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
  `ship_address` VARCHAR(100) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tracking_number` VARCHAR(80) CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci' NULL DEFAULT NULL,
  `order_status_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`audit_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `estore`.`user_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estore`.`user_audit` (
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

CREATE DEFINER=CURRENT_USER TRIGGER role_audit_delete
BEFORE DELETE
ON `role`
FOR EACH ROW
BEGIN
  INSERT INTO role_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
  VALUES (OLD.ID, 'D', NOW(), @username, OLD.TYPE, OLD.DESCRIPTION);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: user
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER user_audit_insert
BEFORE INSERT
ON `user`
FOR EACH ROW
BEGIN
  DECLARE PK_ID INTEGER UNSIGNED default 0;

  SELECT AUTO_INCREMENT INTO PK_ID
  FROM information_schema.tables
  WHERE table_name = 'user'
  AND table_schema = DATABASE();

  INSERT INTO user_audit (`id`, `operation`, `transdate`, `user`, `email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`)
  VALUES (PK_ID, 'I', NOW(), @username, NEW.EMAIL, NEW.PASSWORD, NEW.FIRSTNAME, NEW.LASTNAME, NEW.PHONE, NEW.ADDRESS, NEW.ROLE_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER user_audit_update
BEFORE UPDATE
ON `user`
FOR EACH ROW
BEGIN
	INSERT INTO user_audit (`id`, `operation`, `transdate`, `user`, `email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`)
	VALUES (NEW.ID, 'U', NOW(), @username, NEW.EMAIL, NEW.PASSWORD, NEW.FIRSTNAME, NEW.LASTNAME, NEW.PHONE, NEW.ADDRESS, NEW.ROLE_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER user_audit_delete
BEFORE DELETE
ON `user`
FOR EACH ROW
BEGIN
	INSERT INTO user_audit (`id`, `operation`, `transdate`, `user`, `email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`)
	VALUES (OLD.ID, 'U', NOW(), @username, OLD.EMAIL, OLD.PASSWORD, OLD.FIRSTNAME, OLD.LASTNAME, OLD.PHONE, OLD.ADDRESS, OLD.ROLE_ID);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: product_category
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER product_category_audit_insert
BEFORE INSERT
ON `product_category`
FOR EACH ROW
BEGIN
  INSERT INTO product_category_audit (`id`, `operation`, `transdate`, `user`, `name`, `description`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.NAME, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER product_category_audit_update
BEFORE UPDATE
ON `product_category`
FOR EACH ROW
BEGIN
	INSERT INTO product_category_audit (`id`, `operation`, `transdate`, `user`, `name`, `description`)
	VALUES (NEW.ID, 'U', NOW(), @username, NEW.NAME, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER product_category_audit_delete
BEFORE DELETE
ON `product_category`
FOR EACH ROW
BEGIN
  INSERT INTO product_category_audit (`id`, `operation`, `transdate`, `user`, `name`, `description`)
  VALUES (OLD.ID, 'D', NOW(), @username, OLD.NAME, OLD.DESCRIPTION);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: product
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER product_audit_insert
BEFORE INSERT
ON product
FOR EACH ROW
BEGIN
  DECLARE PK_ID INTEGER UNSIGNED default 0;

  SELECT AUTO_INCREMENT INTO PK_ID
  FROM information_schema.tables
  WHERE table_name = 'product'
  AND table_schema = DATABASE();
  
  INSERT INTO product_audit (`id`, `operation`, `transdate`, `user`, `sku`, `name`, `price`, `quantity`, `description`, `thumb_path`, `image_path`, `product_category_id`)
  VALUES (PK_ID, 'I', NOW(), @username, NEW.SKU, NEW.NAME, NEW.PRICE, NEW.QUANTITY, NEW.DESCRIPTION, NEW.THUMB_PATH, NEW.IMAGE_PATH, NEW.PRODUCT_CATEGORY_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER product_audit_update
BEFORE UPDATE
ON product
FOR EACH ROW
BEGIN
	INSERT INTO product_audit (`id`, `operation`, `transdate`, `user`, `sku`, `name`, `price`, `quantity`, `description`, `thumb_path`, `image_path`, `product_category_id`)
	VALUES (NEW.ID, 'U', NOW(), @username, NEW.SKU, NEW.NAME, NEW.PRICE, NEW.QUANTITY, NEW.DESCRIPTION, NEW.THUMB_PATH, NEW.IMAGE_PATH, NEW.PRODUCT_CATEGORY_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER product_audit_delete
BEFORE DELETE
ON product
FOR EACH ROW
BEGIN
	INSERT INTO product_audit (`id`, `operation`, `transdate`, `user`, `sku`, `name`, `price`, `quantity`, `description`, `thumb_path`, `image_path`, `product_category_id`)
	VALUES (OLD.ID, 'U', NOW(), @username, OLD.SKU, OLD.NAME, OLD.PRICE, OLD.QUANTITY, OLD.DESCRIPTION, OLD.THUMB_PATH, OLD.IMAGE_PATH, OLD.PRODUCT_CATEGORY_ID);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: order_status
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER order_status_audit_insert
BEFORE INSERT
ON `order_status`
FOR EACH ROW
BEGIN
  INSERT INTO order_status_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.TYPE, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_status_audit_update
BEFORE UPDATE
ON `order_status`
FOR EACH ROW
BEGIN
	INSERT INTO order_status_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
	VALUES (NEW.ID, 'U', NOW(), @username, NEW.TYPE, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_status_audit_delete
BEFORE DELETE
ON `order_status`
FOR EACH ROW
BEGIN
  INSERT INTO order_status_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
  VALUES (OLD.ID, 'D', NOW(), @username, OLD.TYPE, OLD.DESCRIPTION);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: order
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER order_audit_insert
BEFORE INSERT
ON `order`
FOR EACH ROW
BEGIN
  DECLARE PK_ID INTEGER UNSIGNED default 0;

  SELECT AUTO_INCREMENT INTO PK_ID
  FROM information_schema.tables
  WHERE table_name = 'order'
  AND table_schema = DATABASE();
  
  INSERT INTO order_audit (`id`, `operation`, `transdate`, `user`, `amount`, `ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`)
  VALUES (PK_ID, 'I', NOW(), @username, NEW.AMOUNT, NEW.SHIP_ADDRESS, NEW.DATE, NEW.TRACKING_NUMBER, NEW.ORDER_STATUS_ID, NEW.USER_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_audit_update
BEFORE UPDATE
ON `order`
FOR EACH ROW
BEGIN
  INSERT INTO order_audit (`id`, `operation`, `transdate`, `user`, `amount`, `ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`)
  VALUES (NEW.ID, 'U', NOW(), @username, NEW.AMOUNT, NEW.SHIP_ADDRESS, NEW.DATE, NEW.TRACKING_NUMBER, NEW.ORDER_STATUS_ID, NEW.USER_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_audit_delete
BEFORE DELETE
ON `order`
FOR EACH ROW
BEGIN
  INSERT INTO order_audit (`id`, `operation`, `transdate`, `user`, `amount`, `ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`)
  VALUES (OLD.ID, 'D', NOW(), @username, OLD.AMOUNT, OLD.SHIP_ADDRESS, OLD.DATE, OLD.TRACKING_NUMBER, OLD.ORDER_STATUS_ID, OLD.USER_ID);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: order_product
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER order_product_audit_insert
BEFORE INSERT
ON `order_product`
FOR EACH ROW
BEGIN
  DECLARE PK_ID INTEGER UNSIGNED default 0;

  SELECT AUTO_INCREMENT INTO PK_ID
  FROM information_schema.tables
  WHERE table_name = 'order_product'
  AND table_schema = DATABASE();
  
  INSERT INTO order_product_audit (`id`, `operation`, `transdate`, `user`, `order_id`, `product_id`)
  VALUES (PK_ID, 'I', NOW(), @username, NEW.ORDER_ID, NEW.PRODUCT_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_product_audit_update
BEFORE UPDATE
ON `order_product`
FOR EACH ROW
BEGIN
  INSERT INTO order_product_audit (`id`, `operation`, `transdate`, `user`, `order_id`, `product_id`)
  VALUES (NEW.ID, 'U', NOW(), @username, NEW.ORDER_ID, NEW.PRODUCT_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_product_audit_delete
BEFORE DELETE
ON `order_product`
FOR EACH ROW
BEGIN
  INSERT INTO order_product_audit (`id`, `operation`, `transdate`, `user`, `order_id`, `product_id`)
  VALUES (OLD.ID, 'D', NOW(), @username, OLD.ORDER_ID, OLD.PRODUCT_ID);
END;
$$

-- -----------------------------------------------------
-- Insert some rows
-- -----------------------------------------------------
INSERT INTO `estore`.`role` (`id`, `type`, `description`) VALUES (1, 'admin', 'admin user');
INSERT INTO `estore`.`role` (`id`, `type`) VALUES (2, 'user');

INSERT INTO `estore`.`user` (`email`, `password`, `firstname`, `lastname`, `role_id`) VALUES ('john1@myestore.com', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4`fafgvaszdfa', 'John', 'Grag', '1');
INSERT INTO `estore`.`user` (`email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`) VALUES ('sandeep@gmail.com', 'f8638b979b2f4f793ddb6dbd197e0ee25a7a6ea32b0ae22f5e3c5d119d839e75', 'Sandeep', 'Guta', '071234567', 'Kungstragården 51 12345 Stockholm', '2');
INSERT INTO `estore`.`user` (`email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`) VALUES ('tommy@gmail.com', 'f8638b979b2f4f793ddb6dbd197e0ee25a7a6ea32b0ae22f5e3c5d119d839e75', 'Tom', 'Campis', '079876542', 'Drotningsgatan 29 12345 Stockholm', '2');
UPDATE `estore`.`user` SET `email` = 'sandeep1@gmail.com' WHERE (`id` = '2');

INSERT INTO `estore`.`product_category` (`id`, `name`, `description`) VALUES (1, 'Electronics', 'Electronics Produts');
INSERT INTO `estore`.`product_category` (`id`, `name`) VALUES (2, 'Clothes');
UPDATE `estore`.`product_category` SET `description` = 'Clothes Products' WHERE (`name` = 'Clothes');

INSERT INTO `estore`.`product` (`sku`, `name`, `price`, `quantity`, `product_category_id`) VALUES ('12345', 'GANT Shirt', '500', '5', '2');

INSERT INTO `estore`.`order_status` (`id`, `type`, `description`) VALUES ('1', 'Pending', 'pending order');
INSERT INTO `estore`.`order_status` (`id`, `type`) VALUES ('2', 'Processing');
INSERT INTO `estore`.`order_status` (`id`, `type`) VALUES ('4', 'Shipped');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
