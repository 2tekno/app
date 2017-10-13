CREATE TABLE `ad` (
	`AdID` BIGINT NOT NULL AUTO_INCREMENT,
	`AccountID` BIGINT NOT NULL,
	`CategoryID` BIGINT NOT NULL,
	`AdText` VARCHAR(1000) NOT NULL,
	`Active` INT NOT NULL,
	`Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`Edited` timestamp,
	`Expired` timestamp,
	PRIMARY KEY (`AdID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
