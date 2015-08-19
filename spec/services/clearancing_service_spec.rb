require 'rails_helper'

describe ClearancingService do
  subject(:clearancing_service) { ClearancingService.new }

  let!(:style) { FactoryGirl.create(:style) }

  let!(:items) do
    FactoryGirl.create_list(:item, 10, style: style)
  end

  describe "#clearance_items!" do
    it 'success clearance batch with item set to clearanced status' do
      item_ids = items[0,5].map(&:id)
      clearance_batch = clearancing_service.clearance_items!(item_ids)
      expect(clearance_batch.persisted?).to be_truthy
      expect(clearance_batch.items.pluck(:status)).to match_array([
                                                        Item::STATUS[:clearanced],
                                                        Item::STATUS[:clearanced],
                                                        Item::STATUS[:clearanced],
                                                        Item::STATUS[:clearanced],
                                                        Item::STATUS[:clearanced],
                                                        ])
    end

    it 'Failed celarance batch ' do
      item_ids = [" ", "test", 9999, 20.5, 0]
      clearance_batch = clearancing_service.clearance_items!(item_ids)
      expect(clearance_batch).to be_nil
    end

     it 'partial success celarance batch with item set to clearanced status ' do
      item_ids = items[0,2].map(&:id)
      item_ids << 9999
      clearance_batch = clearancing_service.clearance_items!(item_ids)
      expect(clearance_batch.persisted?).to be_truthy
      expect(clearance_batch.items.pluck(:status)).to match_array([
                                                        Item::STATUS[:clearanced],
                                                        Item::STATUS[:clearanced]
                                                        ])
    end
  end
end
