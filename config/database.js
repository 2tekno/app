// config/database.js


var connection = {
	'Xhost': 'mrpmanager.com',
	'host': '127.0.0.1',
	'user': 'root',
	'password': 'E#355840',
	'database': 'adappdata',
	'insecureAuth': 'true',
	'multipleStatements': 'true'
}

	
module.exports = {
    'connection': connection,
    'users_table': 'users',
	'path_for_upload': './public/uploads/',
	'ListCategories' : ['Auto','Electronics','Shoes','Tools','Etc.'],
	'ListTypes' : ['For free','Bid It','Buy Now','Make an Offer'],
	'ListLocations' : ['Vancouver','North Vancouver','Burnaby','Richmond','Coquitlam','Port Coquitlam','Maple Ridge','Pitt Meadows','Surrey','Langley']
};

