// $(.button).hover(function() {
//   $(.button_hover).css({'margin: -20px 0 0 0 0'});
// });
$(document).ready(function() {
  $(".button a").hover(function() {
     $(".bottom").slideDown(500);
  }, function(){
  $(".bottom").slideUp(500);
  });
});
