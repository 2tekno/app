var mysql = require('mysql');
var dbconfig = require('../config/database');
var dbqueries = require('../sql/queries');
var connection;



function handleDisconnect() {
  connection = mysql.createConnection(dbconfig.connection); // Recreate the connection, since
                                                  // the old one cannot be reused.

  connection.connect(function(err) {              // The server is either down
    if(err) {                                     // or restarting (takes a while sometimes).
      console.log('error when connecting to db:', err);
      setTimeout(handleDisconnect, 2000); // We introduce a delay before attempting to reconnect,
    }                                     // to avoid a hot loop, and to allow our node script to
  });                                     // process asynchronous requests in the meantime.
                                          // If you're also serving http, display a 503 error.
  connection.on('error', function(err) {
    console.log('db error', err);
    if(err.code === 'PROTOCOL_CONNECTION_LOST') { // Connection to the MySQL server is usually
      handleDisconnect();                         // lost due to either server restart, or a
    } else {                                      // connnection idle timeout (the wait_timeout
      throw err;                                  // server variable configures this)
    }
  });
}

handleDisconnect();


exports.create = function(UserName, Email, Password, done) {
       var data = {
			UserName 	: UserName,
			Email 		: Email,
			Password 	: Password
		};
	var insertQuery = "INSERT INTO users set ? ";
    connection.query(insertQuery, [data], function(err, result) {
		if (err) return done(err)
		else done(null, result.insertId)
	 })
}

exports.createGoogleUser = function(UserName, Email, done) {
       var user = {
			UserName 	: UserName,
			Email 		: Email
		};
		var insertQuery = "INSERT INTO users set ? ";
		connection.query(insertQuery, [user], function(err, result) {
			if (err) return done(err)
			else {
				console.log('result.insertId  === ' + result.insertId);
				user.UserID = result.insertId;
				console.log('user  === ' + JSON.stringify(user));
				done(null, user);
			}
		 })
}

exports.getAllUsers = function(done) {
    connection.query('SELECT * FROM users', function (err, rows) {
    if (err) return done(err)
    done(null, rows)
  })
}

exports.getUserByID = function(userId, done) {
   connection.query('SELECT * FROM users WHERE UserID = ?', userId, function (err, rows) {
    if (err) return done(err)
	var user = {
		UserName: rows[0].UserName,
		Email: rows[0].Email,
		UserID : rows[0].UserID
	};
    done(null, user)
  })
}

exports.getUser = function(userId) {
   connection.query('SELECT * FROM users WHERE UserID = ?', userId, function (err, rows) {
    if (err) return done(err)
	var user = {
		UserName: rows[0].UserName,
		Email: rows[0].Email,
		UserID : rows[0].UserID
	};
    return user;
  })
}

exports.getUserByEmail = function(email, done) {
	console.log('looking for: ' + email);
	
   connection.query('SELECT * FROM users WHERE Email = ?', email, function (err, rows) {
    if (err) return done(err)
	else done(null, rows)
  })
}

exports.getUserByUserName = function(UserName, done) {
	console.log('looking for: ' + UserName);
	
   connection.query('SELECT * FROM users WHERE UserName = ?', UserName, function (err, rows) {
    if (err) return done(err)
	else done(null, rows)
  })
}