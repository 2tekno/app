var LocalStrategy   = require('passport-local').Strategy;
var GoogleStrategy  = require('passport-google-oauth20').Strategy;
var FacebookStrategy = require('passport-facebook').Strategy;

var mysql = require('mysql');
var bcrypt = require('bcrypt-nodejs');
var dbconfig = require('../config/database');
var connection = mysql.createConnection(dbconfig.connection);
var config = require('../config/auth.js');

var users = require('../models/user');

function extractProfile (profile) {

  return {
    UserID: profile.id,
    UserName: profile.displayName,
	Email: profile.Email
  };
}

module.exports = function(passport) {

    // =========================================================================
    // passport session setup ==================================================
    // =========================================================================
    // required for persistent login sessions
    // passport needs ability to serialize and unserialize users out of session

    // used to serialize the user for the session
    passport.serializeUser(function(user, done) {
		console.log('serializeUser ---> ' + JSON.stringify(user));	
		done(null, user.UserID);		
    });


	passport.deserializeUser(function(id, done) {
		users.getUserByID(id, function(err, user){
			//console.log('deserializeUser ---> ' + JSON.stringify(user));	
			done(err, user);
		});
	});
	
	
	
    // =========================================================================
    // LOCAL SIGNUP ============================================================
    // =========================================================================
    // we are using named strategies since we have one for login and one for signup
    // by default, if there was no name, it would just be called 'local'

    passport.use(
        'local-signup',
        new LocalStrategy({
				// by default, local strategy uses username and password, we will override with email
				usernameField : 'username',
				passwordField : 'password',
				passReqToCallback : true // allows us to pass back the entire request to the callback
			},
			function(req, username, password, done) {			
				 users.getUserByEmail(username, function(err, rows) {
				    if(err) {
						return done(err);
				    }
					if (rows.length) {
						return done(null, false, req.flash('signupMessage', 'That username is already taken.'));
					} else {
						var newUserMysql = {
							UserName: username,
							Email: username,
							Password: bcrypt.hashSync(password, null, null)  // use the generateHash function in our user model
						};
						users.create(newUserMysql.UserName, newUserMysql.Email, newUserMysql.Password, function(err, rows) {
							newUserMysql.id = rows.insertId;
							return done(null, newUserMysql);
						});
					}
				});
			}
		)
    );


    // =========================================================================
    // LOCAL LOGIN =============================================================
    // =========================================================================
    // we are using named strategies since we have one for login and one for signup
    // by default, if there was no name, it would just be called 'local'

    passport.use(
        'local-login',
        new LocalStrategy({
            // by default, local strategy uses username and password, we will override with email
            usernameField : 'UserName',
            passwordField : 'Password',
            passReqToCallback : true // allows us to pass back the entire request to the callback
        },
        function(req, UserName, Password, done) { // callback with email and password from our form
           		
			users.getUserByUserName(UserName, function(err, rows) {
					if(err) {return done(err);}
					if (!rows.length) {
						return done(null, false, req.flash('loginMessage', 'No user found.'));
					} 
					if (!bcrypt.compareSync(Password, rows[0].Password))
						return done(null, false, req.flash('loginMessage', 'Oops! Wrong password.')); 

					return done(null, rows[0]);
				});					
        })
    );
	

	passport.use(
			new GoogleStrategy({
				  clientID: config.google.clientID,
				  clientSecret: config.google.clientSecret,
				  callbackURL: config.google.callbackURL,
				  passReqToCallback: true
			},
		  function(req, accessToken, refreshToken, profile, done) {
				
				var ip = req.headers['x-forwarded-for'] || 
							 req.connection.remoteAddress || 
							 req.socket.remoteAddress ||
							 req.connection.socket.remoteAddress;
				
				
				users.getUserByEmail(profile.emails[0].value, function(err, rows) {
					if(err) {return done(err);}
					if (rows.length) {
						console.log('This user already exists.');

						var user = {
							UserName: rows[0].UserName,
							Email: rows[0].Email,
							UserID : rows[0].UserID
						};
						
						req.user = user;  //refresh the session value

						return done(null, user);
												
					} else {
						users.createUser(ip, profile.emails[0].value, profile.emails[0].value, function(err, user) {
							return done(null, user);
						});
					}
				});		   
			   
		  }
	));
	

	passport.use(
		new FacebookStrategy({
		  clientID: config.facebook.clientID,
		  clientSecret: config.facebook.clientSecret,
		  callbackURL: config.facebook.callbackURL,
		  //profileFields: ['id', 'emails', 'name']
passReqToCallback: true
		},
		function(accessToken, refreshToken, profile, done) {
			console.log('req ' + req);
			   var ip ='';
				/*var ip = req.headers['x-forwarded-for'] || 
							 req.connection.remoteAddress || 
							 req.socket.remoteAddress ||
							 req.connection.socket.remoteAddress;
				*/
				users.getUserByEmail(profile.emails[0].value, function(err, rows) {
					if(err) {return done(err);}
					if (rows.length) {
						console.log('This user already exists.');

						var user = {
							UserName: rows[0].UserName,
							Email: rows[0].Email,
							UserID : rows[0].UserID
						};
												
						return done(null, user);
					} else {
						users.createUser(ip, profile.emails[0].value, profile.emails[0].value, function(err, user) {
							return done(null, user);
						});
					}
				});		
			
		}
	));
	

	
};
