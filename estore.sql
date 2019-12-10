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
  `quantity` INTEGER UNSIGNED NOT NULL,
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
  `quantity` INTEGER UNSIGNED NOT NULL,
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
AFTER INSERT
ON `role`
FOR EACH ROW
BEGIN
  INSERT INTO role_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.TYPE, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER role_audit_update
AFTER UPDATE
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
AFTER INSERT
ON `user`
FOR EACH ROW
BEGIN
  INSERT INTO user_audit (`id`, `operation`, `transdate`, `user`, `email`, `password`, `firstname`, `lastname`, `phone`, `address`, `role_id`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.EMAIL, NEW.PASSWORD, NEW.FIRSTNAME, NEW.LASTNAME, NEW.PHONE, NEW.ADDRESS, NEW.ROLE_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER user_audit_update
AFTER UPDATE
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
AFTER INSERT
ON `product_category`
FOR EACH ROW
BEGIN
  INSERT INTO product_category_audit (`id`, `operation`, `transdate`, `user`, `name`, `description`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.NAME, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER product_category_audit_update
AFTER UPDATE
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
AFTER INSERT
ON product
FOR EACH ROW
BEGIN
  INSERT INTO product_audit (`id`, `operation`, `transdate`, `user`, `sku`, `name`, `price`, `quantity`, `description`, `thumb_path`, `image_path`, `product_category_id`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.SKU, NEW.NAME, NEW.PRICE, NEW.QUANTITY, NEW.DESCRIPTION, NEW.THUMB_PATH, NEW.IMAGE_PATH, NEW.PRODUCT_CATEGORY_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER product_audit_update
AFTER UPDATE
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
AFTER INSERT
ON `order_status`
FOR EACH ROW
BEGIN
  INSERT INTO order_status_audit (`id`, `operation`, `transdate`, `user`, `type`, `description`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.TYPE, NEW.DESCRIPTION);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_status_audit_update
AFTER UPDATE
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
AFTER INSERT
ON `order`
FOR EACH ROW
BEGIN
  INSERT INTO order_audit (`id`, `operation`, `transdate`, `user`, `ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.SHIP_ADDRESS, NEW.DATE, NEW.TRACKING_NUMBER, NEW.ORDER_STATUS_ID, NEW.USER_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_audit_update
AFTER UPDATE
ON `order`
FOR EACH ROW
BEGIN
  INSERT INTO order_audit (`id`, `operation`, `transdate`, `user`, `ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`)
  VALUES (NEW.ID, 'U', NOW(), @username, NEW.SHIP_ADDRESS, NEW.DATE, NEW.TRACKING_NUMBER, NEW.ORDER_STATUS_ID, NEW.USER_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_audit_delete
BEFORE DELETE
ON `order`
FOR EACH ROW
BEGIN
  INSERT INTO order_audit (`id`, `operation`, `transdate`, `user`, `ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`)
  VALUES (OLD.ID, 'D', NOW(), @username, OLD.SHIP_ADDRESS, OLD.DATE, OLD.TRACKING_NUMBER, OLD.ORDER_STATUS_ID, OLD.USER_ID);
END;
$$

-- -----------------------------------------------------
-- Triggers for table: order_product
-- -----------------------------------------------------
CREATE DEFINER=CURRENT_USER TRIGGER order_product_audit_insert
AFTER INSERT
ON `order_product`
FOR EACH ROW
BEGIN
  INSERT INTO order_product_audit (`id`, `operation`, `transdate`, `user`, `quantity`, `order_id`, `product_id`)
  VALUES (NEW.ID, 'I', NOW(), @username, NEW.QUANTITY, NEW.ORDER_ID, NEW.PRODUCT_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_product_audit_update
BEFORE UPDATE
ON `order_product`
FOR EACH ROW
BEGIN
  INSERT INTO order_product_audit (`id`, `operation`, `transdate`, `user`, `quantity`, `order_id`, `product_id`)
  VALUES (NEW.ID, 'U', NOW(), @username, NEW.QUANTITY, NEW.ORDER_ID, NEW.PRODUCT_ID);
END;
$$

CREATE DEFINER=CURRENT_USER TRIGGER order_product_audit_delete
BEFORE DELETE
ON `order_product`
FOR EACH ROW
BEGIN
  INSERT INTO order_product_audit (`id`, `operation`, `transdate`, `user`, `quantity`, `order_id`, `product_id`)
  VALUES (OLD.ID, 'D', NOW(), @username, OLD.QUANTITY, OLD.ORDER_ID, OLD.PRODUCT_ID);
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

INSERT INTO `estore`.`product` (`sku`, `name`, `price`, `quantity`, `product_category_id`) VALUES ('123459', 'GANT Shirt', '500', '5', '2');
INSERT INTO `estore`.`product` (`sku`, `name`, `price`, `quantity`, `product_category_id`) VALUES ('122341', 'Samsung TV', '7000', '9', '1');
INSERT INTO `estore`.`product` (`sku`, `name`, `price`, `quantity`, `product_category_id`) VALUES ('122341', 'Philips Vacume Machine', '2000', '6', '1');
INSERT INTO `estore`.`product` (`sku`, `name`, `price`, `quantity`, `product_category_id`) VALUES ('123459', 'Polo Pants', '900', '20', '2');

INSERT INTO `estore`.`order_status` (`id`, `type`, `description`) VALUES ('1', 'Pending', 'pending order');
INSERT INTO `estore`.`order_status` (`id`, `type`) VALUES ('2', 'Processing');
INSERT INTO `estore`.`order_status` (`id`, `type`) VALUES ('4', 'Shipped');

INSERT INTO `estore`.`order` (`ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`) VALUES ('Hanstavagen 89 145 01 Kista', '2019-01-02', 'wkfvhaewnax', '1', '2');
INSERT INTO `estore`.`order` (`ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`) VALUES ('Kungvagen 12 123 45 Stockholm', '2019-02-02', 'asfsdasdfdc', '1', '3');
INSERT INTO `estore`.`order` (`ship_address`, `date`, `tracking_number`, `order_status_id`, `user_id`) VALUES ('Tingvagen 10 194 12 Stockhom', '2019-04-01', 'dvaewsxjalnwdf', '2', '2');

INSERT INTO `estore`.`order_product` (`quantity`, `order_id`, `product_id`) VALUES ('1', '1', '2');
INSERT INTO `estore`.`order_product` (`quantity`, `order_id`, `product_id`) VALUES ('4', '1', '4');
INSERT INTO `estore`.`order_product` (`quantity`, `order_id`, `product_id`) VALUES ('2', '2', '4');
INSERT INTO `estore`.`order_product` (`quantity`, `order_id`, `product_id`) VALUES ('1', '3', '3');
INSERT INTO `estore`.`order_product` (`quantity`, `order_id`, `product_id`) VALUES ('5', '3', '1');
INSERT INTO `estore`.`order_product` (`quantity`, `order_id`, `product_id`) VALUES ('1', '2', '2');

-- -----------------------------------------------------
-- Stored Procedure to analyze data
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Stored Procedure: PerformDataAnalysis
-- -----------------------------------------------------

CREATE PROCEDURE generalDataAnalysis()
BEGIN
    DECLARE totalOrder INT DEFAULT 0;
    DECLARE maxSoldProduct, minSoldProduct VARCHAR(100);
    DECLARE totalRevenue FLOAT DEFAULT 0;
    
	DROP TEMPORARY TABLE IF EXISTS `estore_report`.`tmp_orders_products_quantity`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `estore_report`.`orders_products_quantity` (product_id INT, quantity INT); 
	INSERT INTO orders_products_quantity SELECT product_id, SUM(quantity) FROM `estore`.`order_product` GROUP BY product_id;

	SELECT `name` INTO maxSoldProduct FROM (
		SELECT p.`name`, op.product_id, MAX(op.quantity) AS max_sold FROM `estore`.`product` AS p INNER JOIN `estore_report`.`tmp_orders_products_quantity` AS op WHERE p.id = op.product_id GROUP BY p.id ORDER BY max_sold DESC
	) AS T LIMIT 1;
    
    SELECT `name` INTO minSoldProduct FROM (
		SELECT p.`name`, op.product_id, MIN(op.quantity) AS max_sold FROM `estore`.`product` AS p INNER JOIN `estore_report`.`tmp_orders_products_quantity` AS op WHERE p.id = op.product_id GROUP BY p.id ORDER BY max_sold ASC
	) AS T LIMIT 1;
    
    SELECT SUM(op.quantity * p.price)  INTO totalRevenue FROM `estore`.`order_product` AS op INNER JOIN `estore`.`product` AS p WHERE op.product_id = p.id;
    SELECT COUNT(*) INTO totalOrder FROM `estore`.`order`;
    
    INSERT INTO `estore_report`.`general_analysis` (max_sold_product, min_sold_product, total_revenue, total_number_orders) 
    VALUES (maxSoldProduct, minSoldProduct, totalRevenue, totalOrder);
END$$

CREATE PROCEDURE userDataAnalysis()
BEGIN
	DROP TEMPORARY TABLE IF EXISTS `estore_report`.`tmp_user_analysis`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `estore_report`.`tmp_user_analysis` (`user_id`  INT, `full_name` VARCHAR(50), total_number_orders INT, total_spent FLOAT); 
	DROP TEMPORARY TABLE IF EXISTS `estore_report`.`tmp_total_spent`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `estore_report`.`tmp_total_spent` (`user_id`  INT, total_spent FLOAT); 
	
    
    INSERT INTO `estore_report`.`tmp_user_analysis` (user_id, full_name, total_number_orders) 
    (SELECT u.id AS user_id, CONCAT(u.firstname, ' ', u.lastname) AS `name`, COUNT(o.id) AS total_orders  FROM 
	`estore`.`user` AS u INNER JOIN `estore`.`order` AS o ON u.id = o.user_id 
	GROUP BY u.id);
    
	INSERT INTO `estore_report`.`tmp_total_spent` (user_id, total_spent) 
	(SELECT tua.user_id, SUM(op.quantity * p.price) FROM `estore`.`order_product` AS op 
	INNER JOIN `estore`.`product` AS p ON op.product_id = p.id
	INNER JOIN `estore`.`order` AS o ON op.order_id = o.id
	INNER JOIN `estore_report`.`tmp_user_analysis` AS tua ON o.user_id = tua.user_id
	GROUP BY tua.user_id);

	UPDATE `estore_report`.`tmp_user_analysis` AS tua, `estore_report`.`tmp_total_spent` AS tts 
	SET tua.total_spent = tts.total_spent WHERE tua.user_id = tts.user_id;
    
	INSERT INTO `estore_report`.`user_analysis` (user_id, full_name, total_number_orders, total_spent)
	(SELECT user_id, full_name, total_number_orders, total_spent FROM tmp_user_analysis);

END$$

CREATE PROCEDURE orderDataAnalysis()
BEGIN
	INSERT INTO `estore_report`.`order_analysis` (order_id, total_spent_per_order)
	(SELECT o.id, SUM(op.quantity * p.price) FROM `estore`.`order` AS o 
	INNER JOIN `estore`.`order_product` AS op ON op.order_id = o.id
	INNER JOIN `estore`.`product` AS p ON op.product_id = p.id
	GROUP BY o.id);
END$$

CREATE EVENT generalDataAnalysisEvent
    ON SCHEDULE EVERY 1 HOUR
    DO
      CALL generalDataAnalysis();
      
CREATE EVENT userDataAnalysisEvent
    ON SCHEDULE EVERY 1 HOUR
    DO
      CALL userDataAnalysis();

CREATE EVENT orderDataAnalysisEvent
    ON SCHEDULE EVERY 1 HOUR
    DO
      CALL orderDataAnalysis();

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
