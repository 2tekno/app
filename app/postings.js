var mysql = require('mysql');
var dbconfig = require('../config/database');
var dbqueries = require('../sql/queries');
var fs = require('fs');


var connection;

handleDisconnect();


exports.mylistingData = function(req, res, next){
	var userID = req.user.UserID || 0;
	
	console.log("mylistingData userID " + userID);
	
	var queryStrOLD = 'SELECT * FROM posting where UserID = ?  ORDER BY PostingID DESC';
	var queryStr = 'SELECT A.*,if(B.FileName is null or B.FileName = "","no_images.png",B.FileName) AS FileName FROM posting A LEFT JOIN postingimage B ON B.PostingID=A.PostingID AND B.IsDeleted=0 WHERE A.UserID = ?  GROUP BY A.PostingID ORDER BY A.Created DESC';

     connection.query(queryStr, userID, function(err, data) {

		if (err) { return next(err); }
        
		//console.log('mylisting:' + data);
		
        req.mylistingData = data;
        return next();
    });
};



exports.allpostings = function(req, res){
	var userID = 0;
	var queryStr;
	queryStr = 'SELECT A.*,if(B.FileName is null or B.FileName = "","no_images.png",B.FileName) AS FileName FROM posting A LEFT JOIN postingimage B ON B.PostingID=A.PostingID AND B.IsDeleted=0 GROUP BY A.PostingID ORDER BY A.Created DESC';

	if (req.user!=undefined) {userID = req.user.UserID;}
	var showLogin = true;
	if (req.isAuthenticated()) {
		showLogin = false;
		queryStr = 'SELECT A.*,if(B.FileName is null or B.FileName = "","no_images.png",B.FileName) AS FileName FROM posting A LEFT JOIN postingimage B ON B.PostingID=A.PostingID AND B.IsDeleted=0 WHERE A.UserID !='+userID+' GROUP BY A.PostingID ORDER BY A.Created DESC';
	}
	
	console.log('userId = ' + userID);
	 
	  connection.query(queryStr, function(err, data) {
		if(err) console.log("Error Selecting : %s ", err);
		res.render('allpostings', {page_title: "All Postings", data: data, showLogin: showLogin });
	 });
};

exports.allpostingsOLD = function(req, res){	 	 
	var userID = req.user.UserID || 0;
	var showLogin = true;
	if (req.isAuthenticated()) {
		showLogin = false;
	}
	
   console.log('userId = ' + req.user.UserID);
   res.render('allpostings', {page_title: "All Postings", userID: userID, showLogin: showLogin });
};

exports.alllistData = function(req, res){
     var userID = req.params.userID || 0;
     console.log('userId = ' + userID);
     connection.query("SELECT * FROM posting where UserID != ?  ORDER BY PostingID DESC", userID, function(err, data) {
          if(err) console.log("Error Selecting : %s ", err);
          res.send(data);
     });
};

exports.postingData = function(req, res){
     var PostingID = req.params.PostingID || 0;
     console.log('postingData - > PostingID = ' + PostingID);
     connection.query("SELECT A.* FROM posting A WHERE A.PostingID = ?", PostingID, function(err, data) {
		 
          if(err) console.log("Error Selecting : %s ", err);
          res.send(data);
     });
};

exports.postingDataWithImage = function(req, res){
     var PostingID = req.params.PostingID || 0;
     console.log('postingData - > PostingID = ' + PostingID);
     connection.query("SELECT * FROM posting WHERE PostingID = ?", PostingID, function(err, data) {
		 connection.query("SELECT * FROM postingimage WHERE IsDeleted=0 AND PostingID = ?", PostingID, function(err, images) {
          if(err) console.log("Error Selecting : %s ", err);
		  		  
		   var details = {
              data : data,
			  images : images
          };
		  
          res.send(details);
     });
	 }); 
};

exports.mylistPage = function(req, res){
   var userID = req.user.UserID || 0;
   
	var showLogin = true;
	if (req.isAuthenticated()) {
		showLogin = false;
	}
		
	 connection.query("SELECT * FROM posting where UserID = ?  ORDER BY PostingID DESC", userID, function(err, data) {
	  if(err) console.log("Error Selecting : %s ", err);

    	res.render('myitems', {page_title: "My Postings", userID: userID, showLogin: showLogin, data: data });
		  
		  
     });
		

};

exports.mylistData = function(req, res){
     var userID = req.params.userID || 0;
     console.log('userId = ' + userID);
     connection.query("SELECT * FROM posting where UserID = ?  ORDER BY PostingID DESC", userID, function(err, data) {
          if(err) console.log("Error Selecting : %s ", err);
          res.send(data);
     });
};

exports.postingsByCategory = function(req, res){
    var categoryID = req.params.id || 0;
     connection.query('SELECT * FROM posting WHERE categoryID = ?', categoryID, function(err, data) {
        if(err) console.log("Error Selecting : %s ", err);
        res.send(data);
      });
};

exports.postingsByPostingID = function(req, res){
	var showLogin = true;
	var userID = 0;
	if (req.isAuthenticated()) {
		showLogin = false;
		userID = req.user.UserID;
	}
	//var userID = req.user.UserID || 0;
    var PostingID = req.params.id || 0;
     connection.query('SELECT * FROM posting WHERE PostingID = ?', PostingID, function(err, posting) {
         if(err) console.log("Error Selecting : %s ", err);
		
		 connection.query('SELECT FileName FROM postingimage WHERE IsDeleted=0 AND PostingID = ?', PostingID, function(err, images) {
       
	      var dataPosting = {
              Title : posting[0].Title,
			  PostingText : posting[0].PostingText,
              Price : posting[0].Price,
			  MainImage : images[0].FileName,
			  PostingID : posting[0].PostingID,
			  Type : posting[0].Type,
			  Location : posting[0].Location,
			  Category : posting[0].Category,
			  IsSold : posting[0].IsSold

          };
		  
			//res.send(postingData);
			res.render('posting', { page_title: "Posting", showLogin: showLogin, userID:userID, posting: dataPosting, images: images} );
			  
		 });
      });
};

exports.search = function (req, res) {
	var showLogin = true;
	if (req.isAuthenticated()) {
		showLogin = false;
	}
    res.render('search', { page_title: "search", showLogin: showLogin} );

}

exports.postingsByKeywords = function(req, res){
    var keywordsRaw = req.params.keywords || '';
	var keywords = keywordsRaw.split(" ");
	
	console.log("keywords = ", keywords);

	var filter = '';
	keywords.forEach( function(s) { 
	  filter = filter + " AND A.PostingText LIKE '%" + s + "%'"; 
	});

	console.log("filter = ", filter);

	var oldsqlstring = 'SELECT * FROM posting WHERE 1=1 ' + filter;
	var sqlString = 'SELECT A.PostingID,A.CategoryID,A.PostingText,A.Title,A.Price, B.FileName ' +
                     'FROM posting A LEFT JOIN '+
					 '(SELECT ImageID, PostingID, FileName FROM postingimage WHERE IsDeleted=0 GROUP BY PostingID) b ON B.PostingID = A.PostingID '+
					 'WHERE 1=1 ' + filter +
					 ' ORDER BY A.PostingID DESC';

     connection.query(sqlString, function(err, data) {
        if(err) console.log("Error Selecting : %s ", err);
        res.send(data);
		
		 //res.render('searchResult', {data: data});	
      });
};



exports.listData = function(req, res){
     connection.query('SELECT * FROM posting', function(err, data) {
        if(err) console.log("Error Selecting : %s ", err);
        res.send(data);
      });
};


exports.listPage = function(req, res){
      res.render('postings', {page_title: "Postings"});
};







function handleDisconnect() {
  connection = mysql.createConnection(dbconfig.connection); // Recreate the connection, since

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
};






exports.save_new = function(req, res){

    var input = JSON.parse(JSON.stringify(req.body));
    var categoryID = req.params.categoryID;
    var data = input.adProperties;
    var mandatoryFields_Title = input.mandatoryFields_Title;
    var mandatoryFields_Description = input.mandatoryFields_Description;
    var mandatoryFields_Price = input.mandatoryFields_Price;

    var userID = req.user.UserID;

    //--------------------------------- 
    var dataPosting = {
        Title : mandatoryFields_Title,
        PostingText : mandatoryFields_Description,
        Price : mandatoryFields_Price,
        CategoryID: categoryID,
        Active : 0,
        UserID : userID
    };

	console.log(JSON.stringify(dataPosting));
    
    connection.query("INSERT INTO posting SET ? ", dataPosting, function(err, rows) {
        
        console.log(JSON.stringify(rows));

        var postingId = JSON.stringify(rows['insertId']);
        console.log("Inserted postingId = " + postingId);
    
        for(var obj in data) {
            
            if(data[obj].hasOwnProperty('PropertyID')) {
                var newData = { 
                    PostingID : postingId,
                    PropertyID : data[obj]['PropertyID'],
                    PropertyValue : data[obj]['PropertyValue'] 
                };
                    
                //console.log("newData= " + JSON.stringify(newData));
                
                connection.query("INSERT INTO postingproperty set ? ", newData, function(err, rows) {
                    if (err) console.log("Error inserting : %s ", err);
                });
             }
        }   
    
        if (err) console.log("Error inserting : %s ", err);
        
    });

    
    //--------------------------------- 

    res.redirect('/mypostings');
};




exports.OLDedit = function(req, res){
    var id = req.params.id;
        
    connection.query('SELECT * FROM posting WHERE PostingID = ?', [id], function(err, rows) {
        if(err) console.log("Error Selecting : %s ", err);

        var mandatoryFields = {
            Title : rows[0].Title,
            Description : rows[0].PostingText,
            Price : rows[0].Price
        };

        connection.query(dbqueries.postingPropertiesByPostingID(id), function(err, properties)    {
            if(err) console.log("Error Edit : %s ", err);

            res.render('edit_posting', {page_title: "Edit Posting", properties: properties, id: id, mandatoryFields: mandatoryFields});
        }); 

    });
};



/*Save edited posting*/
exports.OLDsave_edit = function(req, res){
    
      var input = JSON.parse(JSON.stringify(req.body));
      var postingId = req.params.id;
      var data = input.adProperties;
      var mandatoryFields_Title = input.mandatoryFields_Title;
      var mandatoryFields_Description = input.mandatoryFields_Description;
      var mandatoryFields_Price = input.mandatoryFields_Price;

      //--------------------------------- 
      var mandatoryFields = {
          Title : mandatoryFields_Title,
          PostingText : mandatoryFields_Description,
          Price : mandatoryFields_Price
      };

      connection.query("UPDATE posting SET ? WHERE PostingID = ?", [mandatoryFields,postingId], function(err, rows) {
          
          var postingId = JSON.stringify(rows['insertId']);
          console.log("UPDATE posting WHERE PostingID = " + postingId);
      
          for(var obj in data) {
              
              if(data[obj].hasOwnProperty('PropertyID')) {
                  var PostingPropertyID = data[obj]['PostingPropertyID'];
                  var newData = { 
                      PropertyValue : data[obj]['PropertyValue'] 
                  };
                      
                  connection.query("UPDATE postingproperty set ? WHERE PostingPropertyID = ? ", [newData,PostingPropertyID], function(err, rows) {
                      if (err) console.log("Error Updating : %s ", err);
                  });
               }
          }   
      
          if (err) console.log("Error Updating : %s ", err);
          res.redirect('/mypostings');
    
      });
};

exports.details = function(req, res){
    
    var id = req.params.id;
        
    connection.query('SELECT * FROM posting WHERE PostingID = ?', [id], function(err, rows) {
        if(err) console.log("Error Selecting : %s ", err);

        var mandatoryFields = {
            Title : rows[0].Title,
            Description : rows[0].PostingText,
            Price : rows[0].Price
        };

        connection.query(dbqueries.postingPropertiesByPostingID(id), function(err, properties)    {
            if(err) console.log("Error Details : %s ", err);

            res.render('posting_details', {page_title: "Posting", properties: properties, id: id, mandatoryFields: mandatoryFields});
        }); 

    });
};



exports.delete = function(req, res){
    var id = req.params.id;
    connection.query("DELETE FROM posting WHERE PostingID = ? ", [id], function(err, rows) {
        
        if(err) console.log("Error deleting : %s ", err);
    
        res.redirect('/mypostings');
    });
};

exports.upload = function(req, res){
			
	var input = req.body;
	var body_images = []; 
	body_images = req.body.images || [];
	  
	var userID = input.idx || 0;
	var price = input.price || 0;
	console.log('userID == ' + userID);

	var Category = input.category.join(",");
	var Location = input.location;
		  
	var dataPosting = {
		Title : input.title,
		PostingText : input.description,
		Price : input.price,
		Active : 1,
		UserID : userID,
		Type: input.type,
		IsSold: 0,
		Category: Category,
		Location: Location	  
	};
	
	  connection.query("INSERT INTO posting SET ? ", dataPosting, function(err, rows) {
		  
		  var postingId = JSON.stringify(rows['insertId']);
		  upload_image_files(body_images, postingId);
	  
		  if (err) console.log("Error inserting : %s ", err);
		  
	  });
 
      res.end('success');	  
  
};


function upload_image_files(body_images, postingId) {
	if (body_images!=undefined) {
		console.log('L= ' + body_images.length);
		var fileNames = [];
		for(var i=0, len=body_images.length; i<len; ++i) {
		  var fileName = new Date().getTime() + '.png';  
		  var base64Data  = body_images[i].replace(/^data:image\/png;base64,/, "");
		  var buf = new Buffer(base64Data, 'base64');
		  fs.writeFile(dbconfig.path_for_upload+fileName, buf, (err) => {
				if (err) throw err;
				console.log('done');
			});
		  fileNames.push({FileName: fileName});
		}
				  
		for(var obj in fileNames) {	  
		  if(fileNames[obj].hasOwnProperty('FileName')) {
			  var newData = { 
				  PostingID : postingId,
				  FileName : fileNames[obj]['FileName'],
				  IsDeleted : 0 
			  };
				  
			  connection.query("INSERT INTO postingimage set ? ", newData, function(err, rows) {
				  if (err) console.log("Error inserting : %s ", err);
			  });
		   }
		} 
	}
}
exports.edit_item = function(req, res){	
    var postingId = req.params.id;
	var body_images = []; 
	body_images = req.body.images;
	console.log("edit_item post ID " + postingId);        
	var input = req.body;
	var Title = input.title;
	var Description = input.description;
	var Price = input.price;
	var Type = input.type;
	var IsSold=0;
	var Category = input.category.join(",");
	var Location = input.location;
	
	if (input.issold!=undefined) {
		if (input.issold=='on') {
			IsSold=1;
		}
	}
	
	var deletedImages = [];
	if (input.deletedImages != null) { deletedImages = JSON.parse(input.deletedImages);  }
    console.log("deletedImages:  " + JSON.stringify(deletedImages));

	//--------------------------------- 
	var mandatoryFields = {
	  Title : Title,
	  PostingText : Description,
	  Price : Price,
	  Type : Type,
	  Category : Category,
	  Location : Location,
	  IsSold : IsSold
	};
				
    connection.query("UPDATE posting SET ? WHERE PostingID = ?", [mandatoryFields,postingId], function(err, rows) {
          	
		if (deletedImages != null) {
			for(var obj in deletedImages) {
			  if(deletedImages[obj].hasOwnProperty('id')) {
					var id = deletedImages[obj]['id'];
					connection.query("UPDATE postingimage SET IsDeleted = 1 WHERE ImageID='"+id+"'", function(err, rowsImages) {
						 if (err) logger.error("Error deleting from postingimage table: %s ", err);
					})
			  }
			}
		}
		
		upload_image_files(body_images, postingId);
		 
	    if (err) console.log("Error Updating : %s ", err);
	    res.end('success');
	
      });
};


exports.itemDataByPostingID = function(req, res, next){
    var PostingID = req.params.id || 0;
     connection.query('SELECT *,if(Category is null,"",Category) AS Cat FROM posting WHERE PostingID = ?', PostingID, function(err, posting) {
         if(err) console.log("Error Selecting : %s ", err);
		
		 connection.query('SELECT ImageID,FileName FROM postingimage WHERE IsDeleted = 0 AND PostingID = ?', PostingID, function(err, images) {
       
			 var mainImg = '';
			 var imageList = [];
			 var Image = function(ImageID, FileName) {
				this.ImageID = ImageID,
				this.FileName = FileName
				};

			 if (images[0])
			 {
				mainImg = images[0].FileName;	 
				
				for(var i = 0 , len = images.length ; i < len ; i++){
					imageList.push(new Image(images[i].ImageID,images[i].FileName));
				}
			 }
			 
			  var itemData = {
				  Title : posting[0].Title,
				  PostingText : posting[0].PostingText,
				  Price : posting[0].Price,
				  MainImage : mainImg,
				  PostingID : posting[0].PostingID,
				  Location:  posting[0].Location,
				  ListLocations: dbconfig.ListLocations,
				  Email: req.user.Email,
				  Type: posting[0].Type,
				  Category: posting[0].Cat,
				  ImageList: imageList,
				  ListTypes : dbconfig.ListTypes,
				  ListCategories : dbconfig.ListCategories,
				  IsSold : posting[0].IsSold
			  };
		  
				req.itemData = itemData;
				return next();
			  
		 });
      });
};
