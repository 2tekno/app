var mysql = require('mysql');
var dbconfig = require('../config/database');
var dbqueries = require('../sql/queries');
var connection;

handleDisconnect();

exports.propertiesfromcategory = function (req, res) {
 
    var id = req.params.id;
    var mandatoryFields = {
        Title : '',
        Description : '',
        Price : '0'
    };

    connection.query(dbqueries.propertiesByCategory(id), function(err, rows, fields)    {
        res.render('categoryproperty', {page_title: "Category", properties: rows, id: id, mandatoryFields: mandatoryFields});
    }); 
};


exports.save2 = function(req, res){

    var input = JSON.parse(JSON.stringify(req.body));
    var id = req.params.id;
    var data = input.adProperties;


    for(var obj in data) {
        
        if(data[obj].hasOwnProperty('CategoryPropertyID')) {
            console.log("----------Category ID = " + id);
            console.log('CategoryPropertyID -> ' + data[obj]['CategoryPropertyID']);
            console.log('PropertyValue -> ' + data[obj]['PropertyValue']);
            console.log("-------------------------");

            var CategoryPropertyID = data[obj]['CategoryPropertyID'];

            var newData = { PropertyValue : data[obj]['PropertyValue'] };
                
            connection.query("UPDATE categoryproperty set ? WHERE CategoryPropertyID = ? ", [newData,CategoryPropertyID], function(err, rows) {

                if (err) console.log("Error Updating : %s ", err);
                
            });

         }
    }

    //res.send(data);

    res.redirect('/categories');
};



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



exports.getAllProperties = function (req, res, next){
    connection.query("SELECT * FROM property ORDER BY PropertyDescription", function(err, rows) {
        
        if (err || !rows.length) { return next(error);  }
        req.properties = rows;
        return next();
    });
};

exports.getAllPropertyDataTypes = function (req, res, next){
    connection.query("SELECT * FROM propertydatatype ORDER BY PropertyDataTypeDescription", function(err, rows) {
        
        if (err || !rows.length) {  return next(error);  }
        req.propertydatatypes = rows;
        return next();
    });
};

exports.renderPropertiesPage = function (req, res) {
    res.render('properties', {
        page_title: "Properties",
        properties: req.properties
    });
}

exports.PropertyById = function(req, res, next){
    var id = req.params.id;
    connection.query('SELECT * FROM property WHERE PropertyID = ?', [id], function(err, rows) {
       if (err || !rows.length) {  return next(error);  }
        req.property = rows;
        return next();
    });
};

exports.renderPropertyAddPage = function (req, res) {
    res.render('add_property', {
        page_title: "Property",
        propertydatatypes: req.propertydatatypes
    });
}
exports.renderPropertyEditPage = function (req, res) {
    res.render('edit_property', {
        page_title: "Property",
        property: req.property,
        propertydatatypes: req.propertydatatypes
    });
}


exports.save = function(req, res){
    
    var input = JSON.parse(JSON.stringify(req.body));
    var selectedDataType = input.datatype;
             
    var data = {
        PropertyDescription : input.PropertyDescription,
        PropertyDescriptionFull : input.PropertyDescriptionFull,
        PropertyDataTypeID : selectedDataType
    };
        
    connection.query("INSERT INTO property set ? ", data, function(err, rows) {

        if (err) console.log("Error inserting : %s ", err);
        
        res.redirect('/properties');
    });
};


exports.save_edit = function(req, res){
    
    var input = JSON.parse(JSON.stringify(req.body));
    var id = req.params.id;
    var selectedDataType = input.datatype;
    
    console.log("Selected data type: " + selectedDataType);
        
    var data = {
        PropertyDescription : input.PropertyDescription,
        PropertyDescriptionFull : input.PropertyDescriptionFull,
        PropertyDataTypeID : selectedDataType
    };
    
    connection.query("UPDATE property set ? WHERE PropertyID = ? ", [data,id], function(err, rows) {

        if (err) console.log("Error Updating : %s ", err);
        
        res.redirect('/properties');
    });
};

exports.delete = function(req, res){
          
    var id = req.params.id;
       
    connection.query("DELETE FROM property  WHERE PropertyID = ? ", [id], function(err, rows) {
        
            if(err)
                console.log("Error deleting : %s ", err);
        
            res.redirect('/properties');
    });
};
