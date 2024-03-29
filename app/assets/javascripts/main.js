/* Spinner preset */

$.fn.spin.presets.showganizer = {
  lines: 12,
  length: 10,
  width: 4,
  radius: 13,
  color: "#000",
  top: 12,
  left: 12
}


$(document).ready(showganizer);
$(window).on('page:load', showganizer)

$(document).on("click",".flash-bar a.close",function(e) {
		e.preventDefault();
		$(".flash-bar").fadeOut();
});

$(document).on('click', "#top-bar-login-button", function(e) {
		e.preventDefault();
		$("#top-bar-buttons, #top-bar-auth").toggleClass("hidden");
		$("#top-bar-buttons, #top-bar-auth").toggleClass("show");
		$("#top-bar-auth #email").focus();
});

$(document).on("click","#top-bar-auth .close a", function(e) {
		e.preventDefault();
		$("#top-bar-buttons, #top-bar-auth").toggleClass("hidden");
		$("#top-bar-buttons, #top-bar-auth").toggleClass("show");
});

$(document).on("click",".open-review-form", function(e) {
		e.preventDefault();
		if ($(this).hasClass("fade-open-review")) {
			$(this).fadeOut();
		} else {
			$(this).parent('.center-warning').fadeOut();
		}
		$(".review-form-container").slideDown(400, function() {
			$(".review-form-container textarea").focus();
		});
});

$(document).on("click",".close-review-form", function(e) {
		e.preventDefault();
		$(".fade-open-review, #reviews p.center-warning").fadeIn();
		$(".review-form-container").slideUp(400, function(){
			$(".review-form").closest("form")[0].reset();
			$(".review-form-charleft").fadeOut();
			$(".review-form-charleft-number").html(1000);
		});

});

$(document).on("click",".open-post-form", function(e) {
		e.preventDefault();
		if ($(this).hasClass("fade-open-post")) {
			$(this).fadeOut();
		}else {
			$(this).parent('.center-warning').fadeOut();
		}
		$(".post-form-container").slideDown(400, function() {
			$(".post-form-container textarea").focus();
		});
});

$(document).on("change", ".post-form-type-option input", function(e) {
	var type = $(this).val();

	$(".post-form-type-option label").addClass("small");
	$(".post-form-type-option").find(".selected").removeClass('selected');
	$("label[for="+type+"-option]").addClass("selected");

	$(".post-form-type").slideUp(400, function() {
		if (type == "link") {
			var file_input = $("#post-form-file-input");

			file_input.wrap("<form>").parent().get(0).reset();
			$(".post-form-image-filename").html("You have not selected any image.")
			file_input.unwrap();
			file_input.removeAttr('required');
			$("#post-form-link-url").attr('required','required');
		} else if (type = "image") {
			$(".post-form-link input").val("");
			$("#post-form-link-url").removeAttr('required');
			$("#post-form-file-input").attr('required', 'required');
		}
	});
	$(".post-form-"+type+", #post-caption").fadeIn();
});

$(document).on("change", "#post-form-file-input", function(e) {
	var filename_array = $(this).val().split("\\");
	var filename = filename_array[filename_array.length-1];
	$(".post-form-image-filename").html(filename);
});

$(document).on("click",".close-post-form", function(e) {
		e.preventDefault();
		$(".fade-open-post, #posts p.center-warning").fadeIn();
		$(".post-form-container").slideUp(400, function(){
			resetPostForm();
		});
});

$(document).on('click', '.user-content-tabs a', function(e){
		history.pushState({href: $(this).attr('href'), tabsnav: true}, null, $(this).attr('href'));
});

$(window).bind('popstate', function(e) {
	if (e.originalEvent.state.tabsnav == true ) {
		$(".user-content-tabs a[href='"+e.originalEvent.state.href+"']").trigger('click.rails');
	}
});

$(document).bind("ajaxSend", function(){
        $("#loading-indicator").fadeIn();
    }).bind("ajaxComplete", function(){
    	YouShouldntBeVisibleGuys();
        $("#loading-indicator").fadeOut();
});

function showganizer(){
	$(".flash-bar").delay(3000).fadeOut();
	YouShouldntBeVisibleGuys();

	$("#review_content").keyup(function(e) {
		var charleft = 1000-$(this).val().length;
		$(".review-form-charleft-number").html(charleft);
		if(charleft < 0) {
			$(".review-form-charleft").css({
				color: 'red',
				fontWeight: 'bold'
			});
			$(".review-form-submit input").attr('disabled', 'disabled').css({opacity: 0.3});
		} else {
			$(".review-form-charleft").removeAttr("style");
			$(".review-form-submit input").removeAttr('disabled').removeAttr("style");
		}
	}).focus(function(e){
		$(".review-form-charleft").fadeIn();
	});

    /* Spinner */

    $("#loading-indicator").spin('showganizer');


}

function YouShouldntBeVisibleGuys() {
	$(".review-form-container, .review-form-charleft, .post-form-container, .post-form-image, .post-form-link, #post-caption").hide();
}

function resetPostForm() {
	$(".post-form").closest("form")[0].reset();
	$(".post-form-type-option").find(".selected").removeClass('selected');
	$(".post-form-type, #post-caption").hide();
	$(".post-form-type-option label.small").removeClass("small");
	var file_input = $("#post-form-file-input");
	file_input.wrap("<form>").parent().get(0).reset();
	$(".post-form-image-filename").html("You have not selected any image.")
	file_input.unwrap();
}


$(document).on("click",".fill-movie-form", function(e) {
	e.preventDefault();
	var apikey = "49af96950b5c6d76b85aa58a56d38145";
	var baseUrl = "http://api.trakt.tv/search";

	// construct the uri with our apikey
	var moviesSearchUrl = baseUrl + '/movies.json/' + apikey;
	var query = document.getElementById('name').value
	if(!query)
		{query = 0}
  // send off the query
  $.ajax({
    url: moviesSearchUrl + '?query=' + encodeURI(query),
    dataType: "jsonp",
    success: searchCallback
  });
});

// callback for when we get back the results
function searchCallback(data) {
 var movie = data[0];
 	document.getElementById('name').value = movie.title;
 	//alert(movie.release_dates.theater);
 	//ocument.getElementById('date').default = movie.release_dates.theater+' 00:00:00';
 	//document.getElementById('director').value = movie.title;
 	document.getElementById('genre').value = movie.genres;
 	document.getElementById('duration').value = movie.runtime;
 	document.getElementById('description').value = movie.overview;
	document.getElementById('poster').value =  movie.images.poster;
	var yourElement = document.getElementById('info');
 	yourElement.setAttribute('href', movie.url);
 	$("#info").fadeIn();


}


$(document).on("click",".fill-serial-form", function(e) {
	e.preventDefault();
	var apikey = "49af96950b5c6d76b85aa58a56d38145";
	var baseUrl = "http://api.trakt.tv/search";

	// construct the uri with our apikey
	var moviesSearchUrl = baseUrl + '/shows.json/' + apikey;
	var query = document.getElementById('name').value
	if(!query)
		{query = 0}
  // send off the query
  $.ajax({
    url: moviesSearchUrl + '?query=' + encodeURI(query),
    dataType: "jsonp",
    success: searchCallbackserial
  });
});

// callback for when we get back the results
function searchCallbackserial(data) {
 var movie = data[0];
 	document.getElementById('name').value = movie.title;
 	document.getElementById('genre').value = movie.genres;
 	document.getElementById('description').value = movie.overview;
	document.getElementById('poster').value =  movie.images.poster;
	var yourElement = document.getElementById('info');
 	yourElement.setAttribute('href', movie.url);
 	$("#info").fadeIn();


}