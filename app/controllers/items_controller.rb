class ItemsController < ApplicationController
  def index
    @items = Item.order(sort_column + " " + sort_direction)
  end

  helper_method :sort_column, :sort_direction
  private

  def sort_column
    Item.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end