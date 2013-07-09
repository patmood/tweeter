$(document).ready(function() {
  $('#tweet_form').on('submit',function(event){
    event.preventDefault();
    var tweet = $(this).serialize();
    $.ajax({
      url:'/tweet',
      type:'POST',
      data: tweet,
      beforeSend: function(){
        $('#silly').show();
      },
      success: function(data){
        $('#silly').html(data);
      },
      error: function(){
        alert("Fail");
      }
    });
  });
});
