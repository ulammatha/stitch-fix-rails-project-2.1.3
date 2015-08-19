class ClearanceBatchesController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all
  end

  def create
    status_message = "No Item exists for clearance"
    binding.pry
    if session[:clearance_items].present?
      clearancing_batch = ClearancingService.new.clearance_items!(session[:clearance_items])
      if clearancing_batch.persisted?
        status_message = "#{clearancing_batch.items.count} items clearanced in batch #{clearancing_batch.id}"
      else
        status_message  = "No new clearance batch was added"
      end
    end
    session[:clearance_items] = nil
    flash[:notice] = status_message
    redirect_to action: :index
  end

  def report
    @clearanced_batch_items = ClearanceBatch.find(params[:clearance_id]).items
    render layout: false, template: 'clearance_batches/clearance_modal'
  end

  def add_clearance_item
    @item = Item.find_by_id(params[:item_id])
    if @item.present? && @item.status != Item::STATUS[:sellable]
      return render partial: "clearance_batches/flash",
        locals: {
          flash: { alert: "Item could not be clearanced" }
        }

    elsif @item.present? && @item.status == Item::STATUS[:sellable]
      session[:clearance_items] ||= []
      session[:clearance_items] << @item.id
      return render layout: false, template: 'clearance_batches/add_clearance_item'

    end
    render partial: "clearance_batches/flash",
      locals: {
        flash: { alert: "Item not found, Please check the Item id" }
      }
  end

end
