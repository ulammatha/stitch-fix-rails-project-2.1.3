class ClearancingService
  def clearance_items!(item_ids)
    if Item.where(id: item_ids).any?
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
end
