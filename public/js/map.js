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

	var locationsMarkers = new Array();
	var infowindow = new google.maps.InfoWindow();
	var marker;
	var jsonData;

	$.getJSON('reports.json', function(data) {
		jsonData = data;
		var items = [];
		for(var i = 0; i < data.length; i++) {
			var name = 'exclamation';//data[i].report_type.toLowerCase().split(' ').join('');
			var image = 'img/' + name + '.png';
			/*$.ajax({
				url : image,
				type : 'HEAD',
				error : function() {
					image = 'img/crash.png';
				}
			})
			console.log(image);*/

			var shadow = new google.maps.MarkerImage('img/icon_shadow.png', new google.maps.Size(37, 32), new google.maps.Point(0, 0), new google.maps.Point(0, 32));
			marker = new google.maps.Marker({
				position : new google.maps.LatLng(data[i].latitude, data[i].longitude),
				map : map,
				shadow : shadow,
				icon : image
			});

			locationsMarkers.push(marker);

			google.maps.event.addListener(marker, 'click', (function(marker, i) {
				return function() {
					var time = jsonData[i].updated_at;
					var timeRel = jQuery.timeago(time.substring(0, 10));
					var img = (data[i].image_url !== null) ? "<img src=\"" + data[i].image_url + "\">" : "";
					infowindow.setContent("<h3>" + data[i].report_type + "</h3><p>Detail: " + data[i].description + "</p><p>Created by user " + data[i].user_id + " " + timeRel + "</p><p>Confirmation count: " + data[i].confirmation_count + "<br />Inaccuracy count: " + data[i].inaccuracy_count + "</p>" + img + "<button id=\"confirmButton\" onclick=\"confirmButton(" + jsonData[i].id + ")\">Confirm</button><button id=\"inaccurateButton\" onclick=\"inaccurateButton(" + jsonData[i].id + ")\">Mark as inaccurate</button>");
					infowindow.open(map, marker);
				}
			})(marker, i));
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
				var time = jsonData[i].updated_at;
				var timeRel = jQuery.timeago(time.substring(0, 10));

				$("#searchResults").append('<a id=\"result' + i + '\" class=\"result\"><div>' + jsonData[i].report_type + '</div><div class=\"results2\">Updated ' + timeRel + '</div></a>');
				$(".result").click(function() {
					$("#searchResults").children().removeClass('resultSelected');
					$(this).addClass('resultSelected');
					var temp = $(this).attr("id");
					var id = temp.substring(6, temp.length);
					var selectedMarker = locationsMarkers[id];
					map.setCenter(selectedMarker.position);
					map.setZoom(13);
					google.maps.event.trigger(m, 'click');
				});
			}
		}
	});

	google.maps.event.addListener(map, 'click', function() {
		infowindow.close();
	});
	google.maps.event.addListener(map, 'mouseup', function() {
		$("#searchResults").empty();
		var text = "";
		for( i = 0; i < locationsMarkers.length; i++) {
			var m = locationsMarkers[i];
			if(map.getBounds().contains(m.getPosition())) {
				var time = jsonData[i].updated_at;
				var timeRel = jQuery.timeago(time.substring(0, 10));

				$("#searchResults").append('<a id=\"result' + i + '\" class=\"result\"><div>' + jsonData[i].report_type + '</div><div class="results2">Updated ' + timeRel + '</div></a>');
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
	google.maps.event.addListener(map, 'dblclick', function() {
		$("#searchResults").empty();
		var text = "";
		for( i = 0; i < locationsMarkers.length; i++) {
			var m = locationsMarkers[i];
			if(map.getBounds().contains(m.getPosition())) {
				var time = jsonData[i].updated_at;
				var timeRel = jQuery.timeago(time.substring(0, 10));

				$("#searchResults").append('<a id=\"result' + i + '\" class=\"result\"><div>' + jsonData[i].report_type + '</div><div class="results2">Updated ' + timeRel + '</div></a>');
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
	// map visual style
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

	$('form input').click(function() {
		if(this.checked) {

			var gmarkers = locationsMarkers;
			for(var i = 0; i < gmarkers.length; i++) {
				if(gmarkers[i].mycategory == category) {
					gmarkers[i].setVisible(true);
				}
			}
			document.getElementById(category + "box").checked = true;

		} else {
			hide(this.value);
		}
	});
}

function confirmButton(id) {
	$.post('reports/' + id + '/confirm');
}

function inaccurateButton(id) {
	$.post('reports/' + id + '/inaccurate');
}

function hide(type) {
	for(var i = 0; i < gmarkers.length; i++) {
		if(gmarkers[i].mycategory == category) {
			gmarkers[i].setVisible(false);
		}
	}
	document.getElementById(category + "box").checked = false;
	infowindow.close();
}

google.maps.event.addDomListener(window, 'load', initialize);
