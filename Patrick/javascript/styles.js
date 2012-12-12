$(document).ready(function(){
	$('.clickables li').each(function(index, clickable) {
	    console.log("clickable is: %o", $(clickable));
	    $(clickable).on('click', function() {
	    	console.log("hi");
	    	$(this).addClass("clickable");
	       // var link = this.getElement('a');
	        // if(this.getFirst('a')) {
	           // window.location = link
	        // }
	    });
	});

});
