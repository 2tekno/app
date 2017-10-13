var mysql = require('mysql');
var dbconfig = require('../config/database');
var connection = mysql.createConnection(dbconfig.connection);


exports.list = function(req, res){
     connection.query('SELECT * FROM customer', function(err, rows) {
            
        if(err)
           console.log("Error Selecting : %s ", err);
     
        res.render('customers', {page_title: "Customers", data:rows});
      });
};


exports.add = function(req, res){
  res.render('add_customer', {page_title: "Add Customer"});
};

exports.edit = function(req, res){
    
    var id = req.params.id;
        
    connection.query('SELECT * FROM customer WHERE id = ?', [id], function(err, rows) {
        if(err)
            console.log("Error Selecting : %s ", err);

        res.render('edit_customer', {page_title: "Edit Customer", data:rows});
    });
};

/*Save the customer*/
exports.save = function(req, res){
    
    var input = JSON.parse(JSON.stringify(req.body));
        
    var data = {
        name    : input.name,
        address : input.address,
        email   : input.email,
        phone   : input.phone 
    };
        
    connection.query("INSERT INTO customer set ? ", data, function(err, rows) {

        if (err)
            console.log("Error inserting : %s ", err);
        
        res.redirect('/customers');
    });
};

/*Save edited customer*/
exports.save_edit = function(req, res){
    
    var input = JSON.parse(JSON.stringify(req.body));
    var id = req.params.id;
        
    var data = {
        name    : input.name,
        address : input.address,
        email   : input.email,
        phone   : input.phone 
    };
    
    connection.query("UPDATE customer set ? WHERE id = ? ", [data,id], function(err, rows) {

        if (err)
            console.log("Error Updating : %s ", err);
        
        res.redirect('/customers');
    });
};

exports.delete_customer = function(req, res){
          
    var id = req.params.id;
       
    connection.query("DELETE FROM customer  WHERE id = ? ", [id], function(err, rows) {
        
            if(err)
                console.log("Error deleting : %s ", err);
        
            res.redirect('/customers');
    });
};