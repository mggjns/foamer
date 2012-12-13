// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
  $(".edit_li").slideDown();
});

var latitude = null;
var longitude = null;
var latlng = null;

var directionsDisplay;
var map;
var directionsService = new google.maps.DirectionsService();
var rendererOptions = { draggable: true };
var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);


function initialize() {
    "use strict";
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
            latitude = position.coords.latitude;
            longitude = position.coords.longitude;
            var cookie_val = position.coords.latitude + "|" + position.coords.longitude;
            document.cookie = "lat_lng=" + escape(cookie_val);
            // this positions the map on current location
            var latlng = new google.maps.LatLng(latitude,longitude);
            // set direction render options
            // var directionsService = new google.maps.DirectionsService();
            var styles = [
              {
                stylers: [
                  { hue: "#00ffe6" },
                  { saturation: -20 }
                ]
              },{
                featureType: "road",
                elementType: "geometry",
                stylers: [
                  { lightness: 100 },
                  { visibility: "simplified" }
                ]
              },{
                featureType: "road",
                elementType: "labels",
                stylers: [
                  // { visibility: "off" }
                ]
              }
            ];

            var myOptions = {
                zoom: 15,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                scrollwheel: false,
                styles: styles 

            };

            // add the map to the map placeholder
            var map = new google.maps.Map(document.getElementById("mapContainer"),myOptions);
            directionsDisplay.setMap(map); // comment this out to not update the map with directions
            directionsDisplay.setPanel(document.getElementById("directionsPanel"));
            // Add a marker to the map for the end-point of the directions.
            var marker = new google.maps.Marker({
                position: latlng, 
                map: map, 
                title:"Chicago, IL"
            }); 
        });
    }else {
        alert("Geolocation API is not supported in your browser.");
    }
}

function calcRoute() {
    "use strict";
    // get the travelMode from the form, which is defaulted to TRANSIT
    if ($('input[name="travelMode"]:checked')) {
      var travelMode = $('input[name="travelMode"]:checked').val();
      console.log('Found travelMode in form: ' + travelMode);

    } else {
      console.log('No travelMode elements found');
      var travelMode = "TRANSIT";
    }

    // start and end are defined in events/_calcroute_setup.js
    // var start = $("#routeStart_place").val();

    // var end = "1047 W. Webster Avenue, Chicago, IL";

    // <%# TODO: We'll use ArriveBy time someday %>
    // if ($("#routeArrive").length) {
    //   var arrive = $("#routeArrive").val();
    // } else {
    //   console.log('No #routeArrive elements found');
    //   var arrive = "";
    // }

    
    var request = {
      origin: start,
      destination: end,
      transitOptions: {
        arrivalTime: new Date(arrive)
      },
      unitSystem: google.maps.UnitSystem.IMPERIAL,
      travelMode: google.maps.DirectionsTravelMode[travelMode]
    };


    directionsService.route(request, function (response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        $('#directionsPanel').empty(); // clear the directions panel before adding new directions
        directionsDisplay.setDirections(response);
      } else {
        // alert an error message when the route could nog be calculated.
        if (status == 'ZERO_RESULTS') {
          alert('No route could be found between the origin and destination.');
        } else if (status == 'UNKNOWN_ERROR') {
          alert('A directions request could not be processed due to a server error. The request may succeed if you try again.');
        } else if (status == 'REQUEST_DENIED') {
          alert('This webpage is not allowed to use the directions service.');
        } else if (status == 'OVER_QUERY_LIMIT') {
          alert('The webpage has gone over the requests limit in too short a period of time.');
        } else if (status == 'NOT_FOUND') {
          alert('At least one of the origin, destination, or waypoints could not be geocoded.');
        } else if (status == 'INVALID_REQUEST') {
          alert('The DirectionsRequest provided was invalid.');         
        } else {
          alert("There was an unknown error in your request. Requeststatus: nn" + status);
        }
      }
    });
}

$('.submittable').live('change', function() {
  $(this).parents('form:first').submit();
});


$(document).ready(function() {
    // $(initialize(), function() {
    // 	$(calcRoute());
    // });
  initialize();
  calcRoute();
});
