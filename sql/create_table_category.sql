CREATE TABLE `Category` (
	`CategoryID` BIGINT NOT NULL AUTO_INCREMENT,
	`ParentCategoryID` BIGINT NULL DEFAULT '0',
	`CategoryDescription` VARCHAR(200) NULL,
	`CategoryDescriptionFull` VARCHAR(1000) NULL,
	PRIMARY KEY (`CategoryID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


