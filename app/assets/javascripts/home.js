var latitude = null;
var longitude = null;
var latlng = null;

var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
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
            var rendererOptions = { draggable: true };
            directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
            var myOptions = {
                zoom: 15,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                scrollwheel: false
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


