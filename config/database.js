// config/database.js


var connection = {
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
	'ListCategories' : ['Auto','Electronics','Audio','Video','Computers','Employment','Rent','Shoes','Tools','Other'],
	'ListTypes' : ['For free','Bid It','Buy Now','Make an Offer'],
	'ListLocations' : ['Vancouver','North Vancouver','Burnaby','Richmond','Coquitlam','Port Coquitlam','Maple Ridge','Pitt Meadows','Surrey','Langley']
};

