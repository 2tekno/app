var postings = require('./postings');
var categories = require('./categories');
var properties = require('./properties');
var path = require('path');
var fs = require('fs');

//var users = require('./users');
var mysql = require('mysql');
var dbconfig = require('../config/database');
var connection = mysql.createConnection(dbconfig.connection);

var messages = require('./messages');
var users = require('../models/user');

var showLogin = true;



module.exports = function(app, passport) {


    // UPLOAD Images ---------------------------------------------------------

	app.post('/edit_item/:id', postings.edit_item);	
    app.post('/upload', postings.upload);	
    app.get('/upload', isLoggedIn, function(req, res){		
		if (req.isAuthenticated()) {
			showLogin = false;
		}
        var userID = req.user.UserID || 0;
        res.render('new_post', {userID: userID, 
								showLogin: showLogin, 
								ListLocations: dbconfig.ListLocations, 
								ListTypes: dbconfig.ListTypes,
								ListCategories: dbconfig.ListCategories								
								});
    });
    
	
	//app.post('/postings/edit/:id',postings.save_edit);
	app.get('/postings/edit/:id', postings.itemDataByPostingID, isLoggedIn, function(req, res) {
		if (req.isAuthenticated()) {
			showLogin = false;
		}
		res.render('edit_item', {
			itemData: req.itemData,
			showLogin: showLogin,
			user : req.user
		});
	});
	
	
	
	app.get('/mylisting', isLoggedIn,  postings.mylistingData, function(req, res) {
		if (req.isAuthenticated()) {
			showLogin = false;
		}
		res.render('mylisting', {
			mylistingData: req.mylistingData,
			showLogin: showLogin,
			user : req.user
		});
	});
	

	


	app.get('/myInBoxMessages/:userID', messages.myInBoxMessages);
	app.get('/myOutBoxMessages/:userID', messages.myOutBoxMessages);

	app.get('/postingData/:PostingID', postings.postingData);
	app.get('/postingDataWithImage/:PostingID', postings.postingDataWithImage);
	

	app.post('/sendmessage', messages.new_message);

	 app.get('/', function(req, res) {		
		if (req.isAuthenticated()) {
			showLogin = false;
		}

	 	res.render('homepage',{page_title: "Home Page", showLogin: showLogin}); 
	 });
	
	app.get('/search', postings.search);


    app.get('/allpostings', postings.allpostings);
    app.get('/alllistData/:userID', postings.alllistData);  
  
	app.get('/postingsByPostingID/:id', postings.postingsByPostingID);
	
    app.get('/postingsByCategory/:id', postings.postingsByCategory);
	app.get('/postingsByKeywords/:keywords', postings.postingsByKeywords);

    app.get('/categories/section/:id',categories.section);
    app.get('/categories',categories.renderCategorySections);
    app.get('/postings', postings.listPage);
    app.get('/postingsData',postings.listData);   
    app.get('/myListData/:userID', postings.mylistData);
    app.get('/mypostings', isLoggedIn, postings.mylistPage); 
    app.get('/categories/getcategoriesforparentid/:id', categories.getcategoriesforparentid);
    app.get('/categories/subcategories/:id', categories.getAllSubCategories, categories.renderSubCategoriesPage);
    app.get('/properties/propertiesfromcategory/:id', properties.propertiesfromcategory);
    app.post('/properties/save2/:id', properties.save2);
   // app.post('/properties/new_post/:id', properties.new_post);
    app.get('/properties', properties.getAllProperties, properties.renderPropertiesPage);
    app.get('/properties/add', properties.getAllPropertyDataTypes, properties.renderPropertyAddPage);   
    app.post('/properties/add', properties.save);
    app.get('/properties/edit/:id', properties.getAllPropertyDataTypes, properties.PropertyById, properties.renderPropertyEditPage); 
    app.post('/properties/edit/:id', properties.save_edit);   
    app.get('/properties/delete/:id', properties.delete);
     
    //app.get('/categories', categories.getAllCategories, categories.renderCategoriesPage);
    app.get('/categories/add', categories.add);
    app.post('/categories/add', categories.save);
    app.get('/categories/edit/:id', categories.edit); 
    app.post('/categories/edit/:id',categories.save_edit);
    app.get('/categories/delete/:id', categories.delete);
      
      
    app.get('/postings/add', categories.getAllSubCategories, categories.renderSubCategoriesPage);
    app.post('/postings/save_new/:categoryID', postings.save_new);
    
    app.get('/postings/delete/:id', isLoggedIn, postings.delete);
    //app.get('/postings/edit/:id', postings.edit); 
    //app.post('/postings/edit/:id',postings.save_edit);

    app.get('/postings/details/:id', postings.details); 


  

    // PROFILE SECTION =========================
	// =====================================

	app.get('/profile', isLoggedIn, messages.myInBoxMessages, messages.myOutBoxMessages, postings.mylistingData,  function(req, res) {
		if (req.isAuthenticated()) {
			showLogin = false;
		}
		//console.log('req.user **** ' + JSON.stringify(req.user));
		
		res.render('profile', {
			inbox: req.inbox,
			outbox: req.outbox,
			mylistingData: req.mylistingData,
			showLogin: showLogin,
			user : req.user  // get the user out of session and pass to template

		});
	});  
    
 // LOGIN ===============================
    // show the login form
    app.get('/login', function(req, res) {
		if (req.isAuthenticated()) {
			showLogin = false;
		}
		// render the page and pass in any flash data if it exists
		res.render('login', { message: req.flash('loginMessage'), showLogin: showLogin });
	});
    
   /*    app.post('/login', passport.authenticate('local-login', {
            //successRedirect : '/profile', // redirect to the secure profile section
            failureRedirect : '/login', // redirect back to the signup page if there is an error
            failureFlash : true // allow flash messages
        }),
        function(req, res) {
            if (req.body.remember) {
              req.session.cookie.maxAge = 365*5;
            } else {
              req.session.cookie.expires = false;
            }
         res.redirect(req.session.returnTo || '/');
         delete req.session.returnTo;
    });
*/
	
	
	
	
	app.get('/logout', function (req, res){
		
		showLogin = true;
		req.logout();
		res.clearCookie('connect.sid');
		res.render('layouts/header', {showLogin: showLogin});
				
	});



	// SIGNUP ==============================
	// show the signup form
	app.get('/signup', function(req, res) {
		if (req.isAuthenticated()) {
			showLogin = false;
		}
		// render the page and pass in any flash data if it exists
		res.render('signup', { message: req.flash('signupMessage'), showLogin: showLogin });
	});

	// process the signup form
	app.post('/signup', 
		passport.authenticate('local-signup', {
			successRedirect : '/profile', // redirect to the secure profile section
			failureRedirect : '/signup', // redirect back to the signup page if there is an error
			failureFlash : true // allow flash messages
		})
	);
    
	// process with Google ....

   	app.get('/auth/google', function(req, res, next) {
		passport.authenticate('google', {scope: ['profile', 'email']})(req, res, next);		
	});

	
    // the callback after google has authenticated the user
    app.get('/oauth2callback',
		passport.authenticate('google', {
				successRedirect : '/profile',
				failureRedirect : '/'
		})
	);	

	
	// process with Facebook ....

	app.get('/auth/facebook', passport.authenticate('facebook', { scope : 'email' }));
	//app.get('/auth/facebook', passport.authenticate('facebook', {scope: ['profile', 'email']}));			

	
	
	app.get('/auth/facebook/callback',
	  passport.authenticate('facebook', { successRedirect : '/profile', failureRedirect: '/' }),
			  function(req, res) {
				res.redirect('/');
			  }
	);
	
	
	
};

// route middleware to make sure
function isLoggedIn(req, res, next) {

	// if user is authenticated in the session, carry on
	if (req.isAuthenticated()) {return next();}
    else { 
        req.session.returnTo = req.path; 
        res.redirect('/login'); 
    }

}



