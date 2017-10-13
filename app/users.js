var mysql = require('mysql');
var dbconfig = require('../config/database');
var connection = mysql.createConnection(dbconfig.connection);


exports.list = function(req, res){
    connection.query('SELECT * FROM users', function(err, rows) {
        
        if(err)
            console.log("Error Selecting : %s ", err);
        
        res.render('users', {page_title: "Users", data:rows});
    });
};

exports.delete_user = function(req, res){
          
    var id = req.params.id;
       
    connection.query("DELETE FROM users  WHERE UserID = ? ", [id], function(err, rows) {
        
       if(err)
           console.log("Error deleting : %s ", err);
        
        res.redirect('/users');
    });
};