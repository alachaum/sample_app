// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
$(document).ready(function() {

  //alert("Page is loaded");

  var max_micropost_length = 140 ;
  var length_remaining =  max_micropost_length - $(this).val().length ;
  $("#micropost-counter").html(length_remaining);

  $("#micropost_content").keydown(function(event){
    var length_remaining =  max_micropost_length - $(this).val().length ;
    $("#micropost-counter").html(length_remaining);
  });

  $("#micropost_content").keyup(function(event){
    var length_remaining =  max_micropost_length - $(this).val().length ;
    $("#micropost-counter").html(length_remaining);
  });

  $("#micropost_content").keypress(function(event){
    var length_remaining =  max_micropost_length - $(this).val().length ;
    if (length_remaining <=0){
      event.preventDefault();
    }
  });

});
