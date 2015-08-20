class ClearanceBatchesController < ApplicationController

  def index
    @items = Item.where(id: session[:clearance_items]) if session[:clearance_items].present?
    @clearance_batches  = ClearanceBatch.all
  end

  def create
    status_message = "No Item exists for clearance"
    if session[:clearance_items].present?
      clearancing_batch = ClearancingService.new.clearance_items!(session[:clearance_items])
      if clearancing_batch.present? && clearancing_batch.persisted?
        status_message = "#{clearancing_batch.items.count} items clearanced in batch #{clearancing_batch.id}"
      else
        status_message  = "No new clearance batch was added"
      end
    end
    session[:clearance_items] = nil #clearing session
    flash[:notice] = status_message
    redirect_to action: :index
  end

  def report
    @clearanced_batch = ClearanceBatch.find(params[:clearance_id])
    render layout: false, template: 'clearance_batches/clearance_modal'
  end

  def add_clearance_item
    @item = Item.find_by_id(params[:item_id])

    return render partial: "layouts/flash",
    locals: {
      flash: { alert: "Item not found, Please check the Item id" }
    } if @item.nil?

    return render_template(@item)
  end

  def remove_clearance_item
    item_id = params[:item_id].to_i
    if session[:clearance_items].include?(item_id)
      item_id = session[:clearance_items].delete(params["item_id"].to_i)
      return render json: {removed_item_id: item_id}
    end
  end

  private

  def render_template(item)
    if item.status == Item::STATUS[:sellable]
      if session[:clearance_items].present? && session[:clearance_items].include?(item.id)
        return render partial: "layouts/flash",
                      locals: { flash: { alert: "Item is already added in to clearance list"} }
      end
      session[:clearance_items] ||= []
      session[:clearance_items] << item.id
      return render layout: false, template: 'clearance_batches/add_clearance_item', locals: {item: @item}
    end
    render partial: "layouts/flash",
          locals: { flash: { alert: "Item could not be clearanced"} }
  end
end
