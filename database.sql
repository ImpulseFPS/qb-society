CREATE TABLE `society` (
	`name` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`money` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `phone_invoices` (
	`#` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`amount` INT(11) NOT NULL DEFAULT '0',
	`invoiceid` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`sender` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`type` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`#`) USING BTREE,
	INDEX `citizenid` (`citizenid`(768)) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=4
;