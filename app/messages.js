var mysql = require('mysql');
var dbconfig = require('../config/database');
var connection = mysql.createConnection(dbconfig.connection);


exports.myInBoxMessages = function(req, res, next){
	var userID = req.user.UserID || 0;
	
	//console.log("myInBoxMessages userID " + userID);
	
    connection.query("SELECT A.*, DATE_FORMAT(A.Created, '%m-%d-%Y') MessageDate,CASE WHEN U.UserName Is NULL THEN U.Email ELSE U.UserName END Sender " + 
					 "FROM messages A INNER JOIN users U ON U.UserID = A.SenderUserID  WHERE A.ReceiverUserID = ? ORDER BY A.Created DESC", userID, function(err, data) {
        

		if (err) { return next(err); }
        
        req.inbox = data;
        return next();
    });
};

exports.myOutBoxMessages = function(req, res, next){
	var userID = req.user.UserID || 0;
    connection.query("SELECT A.*, DATE_FORMAT(A.Created, '%m-%d-%Y') MessageDate,CASE WHEN U.UserName Is NULL THEN U.Email ELSE U.UserName END ReceiveUser  " + 
					 "FROM messages A INNER JOIN users U ON U.UserID = A.ReceiverUserID WHERE A.SenderUserID = ? ORDER BY A.Created DESC", userID, function(err, data) {
        
        if (err) { return next(err); }
        
		req.outbox = data;
        return next();
    });
};

exports.new_message = function(req, res){
			
      var input = req.body;
    
	  var newmessage = {
		  PostingID : input.postingID,
		  MessageSubject : input.subject,
		  MessageText : input.message,
		  SenderUserID : input.userID,
		  ReceiverUserID : 0,
		  ParentMessageID : input.ParentMessageID
	  };

	  var sqlString;
	  if (newmessage.ParentMessageID!=0)
		  sqlString = "SELECT SenderUserID FROM messages WHERE MessageID = " + newmessage.ParentMessageID;
	  else
		  sqlString = "SELECT UserID SenderUserID FROM posting WHERE PostingID = " + newmessage.PostingID;
	  
	  connection.query(sqlString, function(err, data) {
			
		  newmessage.ReceiverUserID = data[0].SenderUserID;
	  
		  connection.query("INSERT INTO messages SET ? ", newmessage, function(err, rows) {
				  
			  if (err) console.log("Error inserting : %s ", err);
			  
		  });
	  });
	  

      res.end('success');
	  
	  //res.redirect('/mypostings');
	  
};
