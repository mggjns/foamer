$(document).ready(function(){


$('.submittable').on('click', function() {
			$(".clickable").removeClass("clickable");	
	    	console.log("workin on it");
	    	var buttonid = $(this).attr('id');
	    	$('#' + buttonid).addClass("clickable");	       
	    });
	


});
