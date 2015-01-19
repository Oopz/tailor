if (typeof jQuery !== 'undefined') {
	(function($) {
		// DO SOMETHING...
	})(jQuery);
}


function formatSize(bytes) {
    if(null==bytes || 0==bytes) return "--";
    var units=["", " KB", " MB", " GB", " TB"];
    
    var i=0;
    while(1023 < bytes && i<units.length-1){
        bytes /= 1024;
        ++i;
    };
    return i?bytes.toFixed(2) + units[i] : bytes + " Bytes";
}



