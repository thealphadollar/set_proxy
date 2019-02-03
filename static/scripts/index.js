
$(document).ready(function() {
  $(".button a").hover(function() {
     $(".bottom").slideDown(500);
  }, function(){
  $(".bottom").slideUp(500);
  });
});
