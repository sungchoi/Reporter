$(function() {
	$('#map_canvas').gmap({
		'center' : '-33.890542, 151.274856',
		'zoom' : 10,
		'disableDefaultUI' : true,
		'callback' : function() {
			var self = this;

			var locations = [['Bondi Beach', -33.890542, 151.274856, 4], ['Coogee Beach', -33.923036, 151.259052, 5], ['Cronulla Beach', -34.028249, 151.157507, 3], ['Manly Beach', -33.80010128657071, 151.28747820854187, 2], ['Maroubra Beach', -33.950198, 151.259302, 1]];
			for(var i = 0; i < locations.length; i++) {
				marker = locations[i];
				var type = marker[0];
				self.addMarker({
					'position' : new google.maps.LatLng(marker[1], marker[2]),
				}).click(function() {
					console.log(marker[0]);
					self.openInfoWindow({
						'content' : type
					}, this);
				});
			}

		}
	});
});
