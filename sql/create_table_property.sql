CREATE TABLE `Property` (
	`PropertyID` BIGINT NOT NULL AUTO_INCREMENT,
	`PropertyDescription` VARCHAR(200) NULL,
	`PropertyDescriptionFull` VARCHAR(1000) NULL,
	`PropertyDataTypeID` INT NULL,
	PRIMARY KEY (`PropertyID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


