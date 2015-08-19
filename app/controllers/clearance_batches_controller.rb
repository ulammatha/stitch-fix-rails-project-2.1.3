class ClearanceBatchesController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all
  end

  def create
    clearancing_status = ClearancingService.new.process_file(params[:csv_batch_file].tempfile)
    clearance_batch    = clearancing_status.clearance_batch
    alert_messages     = []
    if clearance_batch.persisted?
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end
    if clearancing_status.errors.any?
      alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
      clearancing_status.errors.each {|error| alert_messages << error }
    end
    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    redirect_to action: :index
  end

  def report
    @clearanced_batch_items = ClearanceBatch.find(params[:clearance_id]).items
    render layout: false, template: 'clearance_batches/clearance_modal'
  end

  def clearance_item
    @item = Item.find_by_id(params[:item_id])
    binding.pry
    if @item.present?
      # session[:clearance_items] ||= []
      # session[:clearance_items] << @item
      render layout: false, template: 'clearance_batches/clearance_item'
      return
      # return item.to_json(
      #   :only => [ :id, :size, :color, :status ],
      #   :include => { :style => {:only => :type} }
      #   )
    end
    flash[:alert] = "Item not found, Please check the Item id"
  end
end
