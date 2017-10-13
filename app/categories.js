var mysql = require('mysql');
var dbconfig = require('../config/database');
//var connection = mysql.createConnection(dbconfig.connection);
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

//+++++++++++++++++++++++++++++++++++++++++

exports.renderCategorySections = function (req, res) {

    res.render('categories', { page_title: "Categories"} );

}



exports.renderCategorySectionsOLD = function (req, res) {
    res.render('categories' );
}

exports.section = function(req, res){
     var categoryID = req.params.id || 0;

     console.log('categoryID = ' + categoryID);

     connection.query("SELECT * FROM category WHERE CategoryID = ? ", [categoryID], function(err, categoryTitle) {
     connection.query("SELECT * FROM category WHERE ParentCategoryID = ? ", [categoryID], function(err, categories) {
     
        
          if(err) console.log("Error Selecting : %s ", err);
          res.send({categoryTitle: categoryTitle, categories: categories});
     });
     });
};




exports.getcategoriesforparentid = function(req, res){

    var categoryID = req.params.id;
    connection.query("SELECT * FROM category WHERE ParentCategoryID = ? ", [categoryID], function(err, categories) {

        if (err) { return next(error); }
        

          if(categories.length == 0){
                var mandatoryFields = {
                    Title : 'Title here',
                    Description : 'Description here',
                    Price : '0'
                };

                connection.query(dbqueries.propertiesByCategory(categoryID), function(err, rows, fields)    {

                    res.render('add_posting', {page_title: "New Posting", 
                                                    properties: rows, 
                                                    categoryID: categoryID, 
                                                    mandatoryFields: mandatoryFields}
                    );
                });
          }else{

                res.render('selectcategories', {
                            page_title: "Categories",
                            categories: categories  }
                );
          }
    });

};



exports.renderSubCategoriesPage = function(req, res){

  var id = req.params.id;

  if(req.subcategories.length == 0){
        var mandatoryFields = {
            Title : 'Title here',
            Description : 'Description here',
            Price : '0'
        };

        connection.query(dbqueries.propertiesByCategory(id), function(err, rows, fields)    {

            res.render('add_posting', {page_title: "New Posting", 
                                            properties: rows, 
                                            id: id, 
                                            mandatoryFields: mandatoryFields}
            );
        });
  }else{

        res.render('subcategories', {
                    page_title: "Categories",
                    subcategories: req.subcategories  }
        );
  }

};

exports.getAllSubCategories = function(req, res, next){
    var id = req.params.id;
    connection.query("SELECT * FROM category WHERE ParentCategoryID = ? ", [id], function(err, rows) {

        if (err) { return next(error); }
        
        req.subcategories = rows;
        return next();
    });
};


exports.getAllCategories = function (req, res, next){
    connection.query("SELECT * FROM category ORDER BY CategoryDescription", function(err, rows) {
        
        if (err || !rows.length) { return next(error); }

        req.categories = rows;
        return next();
    });
};

exports.renderCategoriesPage = function (req, res) {
    res.render('categories', { page_title: "Categories",
                               categories: req.categories }
    );
}


exports.add = function(req, res){
    res.render('add_category', {page_title: "Add Category", user: req.user});
};

exports.save = function(req, res){
    
    var input = JSON.parse(JSON.stringify(req.body));
            
    var data = {
        CategoryDescription : input.CategoryDescription,
        CategoryDescriptionFull : input.CategoryDescriptionFull
    };
        
    connection.query("INSERT INTO category set ? ", data, function(err, rows) {

        if (err) console.log("Error inserting : %s ", err);
        
        res.redirect('/categories');
    });
};

exports.edit = function(req, res){
    
    var id = req.params.id;
        
    connection.query('SELECT * FROM category WHERE categoryID = ?', [id], function(err, rows) {
        if(err) console.log("Error Selecting : %s ", err);

        res.render('edit_category', {page_title: "Edit Category", data:rows});
    });
};

exports.save_edit = function(req, res){
    
    var input = JSON.parse(JSON.stringify(req.body));
    var id = req.params.id;
        
    var data = {
        CategoryDescription : input.CategoryDescription,
        CategoryDescriptionFull : input.CategoryDescriptionFull
    };
    
    connection.query("UPDATE category set ? WHERE CategoryID = ? ", [data,id], function(err, rows) {

        if (err) console.log("Error Updating : %s ", err);
        
        res.redirect('/categories');
    });
};

exports.delete = function(req, res){
          
    var id = req.params.id;
       
    connection.query("DELETE FROM category  WHERE CategoryID = ? ", [id], function(err, rows) {
        
        if(err) console.log("Error deleting : %s ", err);
    
        res.redirect('/categories');
    });
};