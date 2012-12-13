$(document).ready(function(){


$('.submittable').on('click', function() {
	    	console.log("workin on it");
	    	var buttonid = $('#travelMode_TRANSIT').attr('id');
	    	$('li').attr("id", buttonid).addClass("clickable");
	    	// $('modes.li').attr((this)'id').addClass("clickable");
	       
	    });
	

/*
$('.submittablebike').each(function(index, clickable) {
	    console.log("clickable is: %o", $(clickable));
	    $(clickable).on('click', function() {
	    	console.log("hi");
	    	$('li.clickablebike').addClass("clickable");
	       
	    });
	});

$('.submittablecar').each(function(index, clickable) {
	    console.log("clickable is: %o", $(clickable));
	    $(clickable).on('click', function() {
	    	console.log("hi");
	    	$('li.clickablecar').addClass("clickable");
	       
	    });
	});

$('.submittablewalk').each(function(index, clickable) {
	    console.log("clickable is: %o", $(clickable));
	    $(clickable).on('click', function() {
	    	console.log("hi");
	    	$('li.clickablewalk').addClass("clickable");
	       
	    });
	});

*/

});
