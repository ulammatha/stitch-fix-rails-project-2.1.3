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
      $("#item_id").val('');
    }
  });

  $(document).on("click",".close",function(e){
    $('#clearance_error').remove();
  });

  $(document).on("click",".remove",function(e){
    tr = $(this).closest('tr').attr('id')
    id = tr.replace('item_', '');
    var request = $.ajax({
        url: "/clearance_batches/remove_clearance_item",
        type: 'GET',
        data: {item_id: id}
      });

    request.success(function(data){
      tr_id = "#item_".concat(data["removed_item_id"]);
      $(tr_id).remove();
    });
  });
});