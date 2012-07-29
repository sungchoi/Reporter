function initialize() {
	var mapOptions = {
		center : new google.maps.LatLng(33.508767, 36.308784),
		zoom : 8,
		panControl : false,
		mapTypeId : google.maps.MapTypeId.ROADMAP
	};
	var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

	var input = document.getElementById('searchTextField');
	var autocomplete = new google.maps.places.Autocomplete(input);

	autocomplete.bindTo('bounds', map);

	var infowindow = new google.maps.InfoWindow();

	//var locations = [['Crash', 33.57, 36.3, 4], ['Earthquake', 33.7, 36.8784, 5], ['Fire', 33.508, 36.4, 3], ['Road block', 35.2, 38.2, 2], ['Fire', 33.567, 36.3087, 1]];

	// time created
	// creator
	// time occurred
	// status
	// last action time
	// confirmed count
	// inaccurate count
	// actions: confirm, inaccurate

	var locationsMarkers = new Array();

	var infowindow = new google.maps.InfoWindow();

	var marker, i;

	var jsonData;
	
	$.getJSON('reports.json', function(data) {
		jsonData = data;
		var items = [];
		for(var i = 0; i < data.length; i++) {
			var name = data[i].report_type.toLowerCase().split(' ').join('');
			var image = 'img/' + name + '.png';
			var shadow = new google.maps.MarkerImage('img/icon_shadow.png', new google.maps.Size(37, 32), new google.maps.Point(0, 0), new google.maps.Point(0, 32));
			marker = new google.maps.Marker({
				position : new google.maps.LatLng(data[i].latitude, data[i].longitude),
				map : map,
				shadow : shadow,
				icon : image
			});

			locationsMarkers[i] = marker;
			google.maps.event.addListener(marker, 'click', (function(marker, i) {
				return function() {
					infowindow.setContent(data[i].report_type);
					infowindow.open(map, marker);
				}
			})(marker, i));

			/*console.log(data[0].description);
			$.each(data[i], function(key, val) {
				j = j + 1;
			});*/
		}
	});

	google.maps.event.addListener(autocomplete, 'place_changed', function() {
		infowindow.close();
		var place = autocomplete.getPlace();
		if(place.geometry.viewport) {
			map.fitBounds(place.geometry.viewport);
		} else {
			map.setCenter(place.geometry.location);
			map.setZoom(17);
		}
		$("#searchResults").empty();
		var text = "";
		for( i = 0; i < locationsMarkers.length; i++) {
			var m = locationsMarkers[i];
			if(map.getBounds().contains(m.getPosition())) {
				$("#searchResults").append('<div id=\"result' + i + '\" class=\"result\"><a>' + jsonData[i].report_type + '</a></div>');
				$(".result").click(function() {
					$("#searchResults").children().removeClass('resultSelected');
					$(this).addClass('resultSelected');
					var temp = $(this).attr("id");
					var id = temp.substring(6, temp.length);
					var selectedMarker = locationsMarkers[id];
					map.setCenter(selectedMarker.position);
					map.setZoom(13);
				});
			}
		}
	});
	var styles = [{
		stylers : [{
			hue : "#00ffe6"
		}, {
			saturation : -20
		}]
	}, {
		featureType : "road",
		elementType : "geometry",
		stylers : [{
			lightness : 100
		}, {
			visibility : "simplified"
		}]
	}, {
		featureType : "road",
		elementType : "labels",
		stylers : [{
			visibility : "off"
		}]
	}];

	map.setOptions({
		styles : styles
	});

	/*$("#dialog:ui-dialog").dialog("destroy");

	 $("#dialog-modal").dialog({
	 height : 140,
	 modal : true
	 });*/
}

google.maps.event.addDomListener(window, 'load', initialize);
