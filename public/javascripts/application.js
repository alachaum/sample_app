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

  $(".reply_button").click(function(event){
    var user_id = $(this).attr("user_id");
    var user_name = $(this).attr("user_name");
    var user_link = $(this).attr("link");
    var user_label = '<a href="' + user_link + '">' + user_name + '</a>';
    $("#new_micropost").find(".field").find("#reply_user_name").html('@' + user_label);
    $("#new_micropost").find(".field").find("#micropost_in_reply_to").attr("value", user_id)
  });
});
