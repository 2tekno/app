function addUser(){
            
    window.location.href = '/customers/add';
}

function cancelAdd(){
    
    window.location.href = '/customers';
}

function addPosting(){
            
    window.location.href = '/categories/getCategoriesForParentID/0';
}

function cancelAddPosting(){
    
    window.location.href = '/mypostings';
}

function addCategory(){
            
    window.location.href = '/categories/add';
}

function cancelEditCategory(){
    
    window.location.href = '/categories';
}

function cancelAddCategory(){
    
    window.location.href = '/categories';
}

function addProperty(){
            
    window.location.href = '/properties/add';
}

function cancelAddProperty(){
    
    window.location.href = '/properties';
}

function cancelEditProperty(){
    
    window.location.href = '/properties';
}


function getClientIp(req) {
  var ipAddress;
  // The request may be forwarded from local web server.
  var forwardedIpsStr = req.header('x-forwarded-for'); 
  if (forwardedIpsStr) {
    // 'x-forwarded-for' header may return multiple IP addresses in
    // the format: "client IP, proxy 1 IP, proxy 2 IP" so take the
    // the first one
    var forwardedIps = forwardedIpsStr.split(',');
    ipAddress = forwardedIps[0];
  }
  if (!ipAddress) {
    // If request was not forwarded
    ipAddress = req.connection.remoteAddress;
  }
  return ipAddress;
};