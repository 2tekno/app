var postings = require('./postings');
var categories = require('./categories');
var properties = require('./properties');
var path = require('path');
var fs = require('fs');
var mysql = require('mysql');
var dbconfig = require('../config/database');
var connection = mysql.createConnection(dbconfig.connection);
var messages = require('./messages');
var users = require('../models/user');



module.exports = function(app, passport) {


    // UPLOAD Images ---------------------------------------------------------

	app.post('/itemrating', postings.itemrating);	
	app.post('/getitemrating', postings.getitemrating);	

	app.post('/edit_item/:id', postings.edit_item);	
    app.post('/upload', postings.upload);	
   
	app.get('/upload', isLoggedIn,categories.getAllCategories,  function(req, res){		

        var userID = req.user.UserID || 0;
        res.render('add_item', {userID: userID, 
								user: req.user,
								ListLocations: dbconfig.ListLocations, 
								ListTypes: dbconfig.ListTypes,	
								ListCategories: req.categories
								});
    });
    
	
	app.get('/postings/edit/:id', isLoggedIn, postings.itemDataByPostingID, categories.getAllCategories, function(req, res) {

		res.render('edit_item', {
			itemData: req.itemData,
			ListLocations: dbconfig.ListLocations, 
			ListTypes: dbconfig.ListTypes,	
			ListCategories: req.categories,
			user : req.user
		});
	});
	
	
	app.get('/mylisting', isLoggedIn,  postings.mylistingData, function(req, res) {

		//console.log(req.mylistingData);

		res.render('mylisting', {
			mylistingData: req.mylistingData,
			user : req.user
		});
	});
	

	app.get('/myInBoxMessages/:userID', messages.myInBoxMessages);
	app.get('/myOutBoxMessages/:userID', messages.myOutBoxMessages);

	app.get('/postingData/:PostingID', postings.postingData);
	app.get('/postingDataWithImage/:PostingID', postings.postingDataWithImage);
	

	app.post('/sendmessage', messages.new_message);

	app.get('/', postings.allpostings);

	app.get('/search', postings.search);


	app.get('/allpostings/:searchtext', postings.allpostings);
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
    app.get('/properties', properties.getAllProperties, properties.renderPropertiesPage);
    app.get('/properties/add', properties.getAllPropertyDataTypes, properties.renderPropertyAddPage);   
    app.post('/properties/add', properties.save);
    app.get('/properties/edit/:id', properties.getAllPropertyDataTypes, properties.PropertyById, properties.renderPropertyEditPage); 
    app.post('/properties/edit/:id', properties.save_edit);   
    app.get('/properties/delete/:id', properties.delete);
     
    app.get('/categories/add', categories.add);
    app.post('/categories/add', categories.save);
    app.get('/categories/edit/:id', categories.edit); 
    app.post('/categories/edit/:id',categories.save_edit);
    app.get('/categories/delete/:id', categories.delete);
      
    app.get('/postings/add', categories.getAllSubCategories, categories.renderSubCategoriesPage);
    app.post('/postings/save_new/:categoryID', postings.save_new);
    app.get('/postings/delete/:id', isLoggedIn, postings.delete);
    app.get('/postings/details/:id', postings.details); 


  

    // PROFILE SECTION =========================
	// =====================================

	app.get('/profile', isLoggedIn, messages.myInBoxMessages, messages.myOutBoxMessages, postings.mylistingData,  function(req, res) {
		res.render('profile', {
			inbox: req.inbox,
			outbox: req.outbox,
			mylistingData: req.mylistingData,
			user : req.user  // get the user out of session and pass to template
		});
	});  
    
	
    app.get('/login_local', function(req, res) {
		res.render('login_local', { message: req.flash('loginMessage'), user : req.user });
	});

    app.post('/login_local', passport.authenticate('local-login', {
		successReturnToOrRedirect : '/profile', // redirect to the secure profile section
            failureRedirect : '/login_local', // redirect back to the signup page if there is an error
            failureFlash : true // allow flash messages
        }),
        function(req, res) {
			res.redirect(req.session.returnTo || '/');
			delete req.session.returnTo;
    });
	

	app.get('/signup_local', function(req, res) {
		res.render('signup_local', { message: req.flash('signupMessage') });
	});
	// process the signup form
	app.post('/signup_local', 
		passport.authenticate('local-signup', {
			successReturnToOrRedirect : '/profile', // redirect to the secure profile section
			failureRedirect : '/signup_local', // redirect back to the signup page if there is an error
			failureFlash : true // allow flash messages
		})
	);	


	
	app.get('/logout', function (req, res){
		req.logout();
		res.clearCookie('connect.sid');
		res.render('layouts/header', {user: req.user});
	});



	// SIGNUP ==============================
	// show the signup form
	app.get('/signup', function(req, res) {
		// render the page and pass in any flash data if it exists
		res.render('signup', { message: req.flash('signupMessage') });
	});

	// process the signup form
	app.post('/signup', 
		passport.authenticate('local-signup', {
			successRedirect : '/profile',
			failureRedirect : '/signup',
			failureFlash : true 
		})
	);
    
	// signup with Goggle
   	app.get('/auth/google', function(req, res, next) {
		passport.authenticate('google', {scope: ['profile', 'email'], prompt: 'select_account'})(req, res, next);		
	});

    // the callback after google has authenticated the user
    app.get('/oauth2callback',
		passport.authenticate('google', {
				successRedirect : '/profile',
				failureRedirect: '/signup_local',
				failureFlash : true
		})
	);	


	// signup with FB
	app.get('/auth/facebook', passport.authenticate('facebook', { scope : 'email' }));
	
	app.get('/auth/facebook/callback',
	  passport.authenticate('facebook', { 
			successRedirect : '/profile', 
			failureRedirect: '/signup_local',
			failureFlash : true }),
			  function(req, res) {res.redirect('/'); }
	);
	


};

// route middleware to make sure
function isLoggedIn(req, res, next) {
	if (req.user) {
		return next();
	}
    else { 
        req.session.returnTo = req.path; 
        res.redirect('/login_local'); 
    }
}



