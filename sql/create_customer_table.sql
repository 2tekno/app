CREATE TABLE customer (
  id int(11) NOT NULL AUTO_INCREMENT,
  name char(50) NOT NULL DEFAULT '',
  address char(200) NOT NULL DEFAULT '',
  email char(100) NOT NULL DEFAULT '',
  phone char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
