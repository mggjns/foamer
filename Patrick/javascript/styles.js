$(document).ready(function(){


$('.submittable').on('click', function() {
			$(".clickable").removeClass("clickable");	
	    	console.log("workin on it");
	    	var buttonid = $(this).attr('id');
	    	$('#' + buttonid).addClass("clickable");	       
	    });
	

/*

	    	$('li').attr('id', 'buttonid').addClass("clickable");



$('li "#buttonid"'')

$('li')


$('.submittablewalk').each(function(index, clickable) {
	    console.log("clickable is: %o", $(clickable));
	    $(clickable).on('click', function() {
	    	console.log("hi");
	    	$('li.clickablewalk').addClass("clickable");
	       
	    });
	});

*/

});
