$(function() {
  $(document).on("click",".clearance_report",function(e){
    id = '#'.concat($(this).attr("id"))
    $(id).on('ajax:success', function (event, data, status, xhr) {
      $(".modal").html(data)
       $(".modal").modal({backdrop: 'static'});
      $(".modal").modal('show');
      });
  });

  $('#item_clearance').on('ajax:success', function (event, data, status, xhr) {
    if($(data).find('#clearance_error').length > 0) {
      $("#flash").html(data);
    }
    else {
      $("#item_clearance_table").append(data);
    }
  });

  $(document).on("click",".close",function(e){
    $('#clearance_error').remove();
  });

});