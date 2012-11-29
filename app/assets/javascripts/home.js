var latitude = null;
var longitude = null;

var directionDisplay;
var directionsService = new google.maps.DirectionsService();
function initialize() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position){
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
                zoom: 14,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false
            };
            // add the map to the map placeholder
                var map = new google.maps.Map(document.getElementById("mapContainer"),myOptions);
                directionsDisplay.setMap(map);
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
    // get the travelmode, startpoint and end point from the form       
    var travelMode = $('input[name="travelMode"]:checked').val();
    var start = $("#routeStart_place_id").val();
    var via = $("#routeVia").val();
    if (travelMode == 'TRANSIT') {
        via = ''; // if the travel mode is transit, don't use the via waypoint because that will not work
    }
    var end = $("#routeVia").val(); // no it isn't...endpoint is a geolocation
    
    // gotta have this one
    var waypoints = []; // init an empty waypoints array
    
// comment out this 'if' and the map goes away
    if (via != '') {
        // if waypoints (via) are set, add them to the waypoints array
        waypoints.push({
          location: via,
          stopover: true
        });
    }
   
    var request = {
        origin: start,
        destination: end,
        unitSystem: google.maps.UnitSystem.IMPERIAL,
        travelMode: google.maps.DirectionsTravelMode[travelMode] 
        // transitOptions: { arrivalTime: new Date(1337675679473) }

    };
    directionsService.route(request, function(response, status) {
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
                alert("There was an unknown error in your request. Requeststatus: \n\n"+status);
            }
        }
    });
}
