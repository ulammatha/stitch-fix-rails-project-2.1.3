# creates a clearance batch for the list of items
class ClearancingService
  # Returns the clearance_batch
  # method takes array of items which needs to be clearanced as batch
  #
  # For example:
  #   item_ids= [1,2,3,4]
  #  return #<ClearanceBatch:0x007fdebb2df518>
  def clearance_items!(item_ids)
    return nil if Item.where(id: item_ids).empty?
    clearance_batch = ClearanceBatch.new
    Item.transaction do
      item_ids.each do |item_id|
        item = Item.find_by_id(item_id)
        next if item.nil?
        item.clearance_batch = clearance_batch
        item.clearance!
      end
      clearance_batch.save
    end
    clearance_batch
  end
end
