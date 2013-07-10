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
        $('#silly').show();
      },
      success: function(data){
        $('#silly').html(data.content);
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
        console.log(data);
        if(! data.done) {
          beginPollingJob(jobId);
        }
      },
      error: function(){
        beginPollingJob(jobId);
      }
    });
  },50);
}
