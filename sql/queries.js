// sql/queries.js


exports.propertiesByCategory = function (CategoryID){
    
        return "SELECT a.CategoryID,a.PropertyID,a.PropertyValue,a.CategoryPropertyID,b.CategoryDescription,c.PropertyDescription,d.PropertyDataTypeDescription, '' AS Value  " +
				"FROM categoryproperty a INNER JOIN category b ON b.CategoryID = a.CategoryID " +
				"INNER JOIN property c on c.PropertyID = a.PropertyID " +
				"INNER JOIN propertydatatype d ON d.PropertyDataTypeID = c.PropertyDataTypeID " +
				"WHERE a.CategoryID =  " + CategoryID + " ORDER BY c.PropertyDescription";

};


exports.postingPropertiesByPostingID = function (PostingID){
    
        return "SELECT a.PostingID,b.PostingPropertyID,a.CategoryID,c.PropertyID,c.PropertyDescription,d.PropertyDataTypeDescription,b.PropertyValue  " +
				"FROM posting a INNER JOIN postingproperty b on b.PostingID=a.PostingID " +
				"INNER JOIN property c on c.PropertyID=b.PropertyID " +
				"INNER JOIN propertydatatype d ON d.PropertyDataTypeID = c.PropertyDataTypeID " +
                "INNER JOIN categoryproperty e ON e.CategoryID = a.CategoryID AND e.PropertyID = c.PropertyID WHERE a.PostingID =  " + PostingID + 
				" ORDER BY e.Sequence, c.PropertyDescription";
};