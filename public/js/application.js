// function checkPosted(){
//   console.log("check");
// }

$(document).ready(function() {
  $('#tweet_form').on('submit',function(event){
    event.preventDefault();
    var tweet = $(this).serialize();
    $.ajax({
      url:'/tweet',
      type:'POST',
      data: tweet,
      beforeSend: function(){
        // disable button
        $('input[type="submit"]').attr('disabled', 'disabled');
        $('#silly').show();
      },
      success: function(data){
        beginPollingJob(data.job_id);
      },
      error: function(){
        alert("Fail");
      }
    });
  });
});

function beginPollingJob(jobId) {
  setTimeout(function(){
    $.ajax({
      url:'/status/' + jobId,
      type:'GET',
      success: function(data){
        if(! data.done) {
          beginPollingJob(jobId);
        } else {
          successAction();
        }
      },
      error: function(){
        beginPollingJob(jobId);
      }
    });
  },50);
}

function successAction(){
  $('input[type="submit"]').removeAttr('disabled');
  $.ajax({
      url:'/tweet_list',
      type:'POST',
      success: function(data){
        $('#silly').html(data.content);
      },
      error: function(){
        alert("Fail");
      }
    });
};
