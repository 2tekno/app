CREATE TABLE posting (
  id int(11) NOT NULL AUTO_INCREMENT,
  user_id int(11) NOT NULL,
  posting_title varchar(200) NOT NULL DEFAULT '',
  posting_body varchar(1000) NOT NULL DEFAULT '',
  price decimal(12,2) NOT NULL,
  make varchar(200) NULL,
  model varchar(200) NULL,
  item_condition varchar(200) NULL,
  posting_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  posting_update_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
