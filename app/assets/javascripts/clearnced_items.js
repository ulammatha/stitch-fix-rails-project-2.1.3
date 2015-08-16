$(function() {
  $(document).on("click",".clearance_report",function(e){
    id = '#'.concat($(this).attr("id"))
    $(id).on('ajax:success', function (event, data, status, xhr) {
      $(".modal").html(data)
       $(".modal").modal({backdrop: 'static'});
      $(".modal").modal('show');
      });
  });
});