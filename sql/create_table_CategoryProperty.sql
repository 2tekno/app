CREATE TABLE `CategoryProperty` (
	`CategoryPropertyID` BIGINT NOT NULL AUTO_INCREMENT,
	`CategoryID` BIGINT NOT NULL,
	`PropertID` BIGINT NOT NULL,
	`PropertyValue` VARCHAR(200) NULL,
	PRIMARY KEY (`CategoryPropertyID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


