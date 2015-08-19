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
    $("#item_clearance_table").append(data)
  });

  $('#remove_item').on("click",".clearance_report",function(e){
    $(this).closest('tr').remove();
  });
});