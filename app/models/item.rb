class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")
  PANTS_AND_DRESSES = ["Pants", "Dress"]
  STATUS = { sellable: "sellable", clearanced: "clearanced" }

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }

  def clearance!
    selling_price = style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
    if selling_price < 5 && PANTS_AND_DRESSES.include?(style.type)
      selling_price = 5
    elsif selling_price < 2
      selling_price = 2
    end
    update_attributes!(status: Item::STATUS['clearanced'], price_sold: selling_price)
  end
end
