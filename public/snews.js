$(function(){
	
	function notify( message ) {
		$("#notifications").html( message );
	};
	
	// notify("Saving snapshot...");
	// 	var state = $("#wrapper").html();
	// 	$.post('/record', { state: state });
	
	$.get('/check_freshness', function( isFresh ) {
		
		if ( isFresh == 'true') {
			// do nothing
			notify("Up to date");
			$("#notifications").show();
		} else {
			notify("These stories are a little stale, hang on one sec...");
			$("#notifications").show();
			$("#wrapper").load('/update #frag', function(){
				
				notify("Stories loaded, loading images...")
				var size = $(".tehot").length - 1;
				
				$(".tehot").each(function(index) {
					var tehot = $(this);
					var term = $(".name", tehot).text().replace(/\s/ig, ',');

					$.getJSON("http://api.flickr.com/services/feeds/photos_public.gne?tags=" + term + "&tagmode=all&format=json&jsoncallback=?", function( data ){
						var strang = "<ul class='flicks'>";
						
						$.each(data.items, function(i,item) {
							strang += "<li><a href='" + item.link + "'><img src='" + (item.media.m).replace("_m.jpg", "_s.jpg") + "' title='" + item.title + "' alt='" + item.title + "' /></a></li>";
							// console.log(i + ":" + strang);
							// if ( i == 9 ) return false;
						});
						
						strang += "</ul>";
						
						tehot.append(strang);
					});
					
					if (index == size) {
						var t = setTimeout(function() {
							notify("Saving snapshot...");
							var state = $("#wrapper").html();
							$.post('/record', { state: state }, function(){
								notify("All done! Enjoy!");
							});
						}, 5000);
					};
					
				});
				
				
			});
		};
	});
});