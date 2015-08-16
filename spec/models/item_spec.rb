require 'rails_helper'

describe Item do
  describe "#clearance!" do
    let(:item) { FactoryGirl.create(:item) }

    it "should mark the item status as clearanced" do
      item.clearance!
      expect(item.status).to eq("clearanced")
    end

    context 'when pants type clearance discount is greater than $5' do
      it "should set the price_sold as 75% of the wholesale_price" do
        item.clearance!
        expect(item.price_sold).to eq(item.style.wholesale_price.to_d * "0.75".to_d)
      end
    end

    context 'when pants type clearance discount is less than $5' do
      it "should set the price_sold to $5" do
        item.style.wholesale_price = 5
        item.save!
        item.clearance!
        expect(item.price_sold).to eq(5.to_d)
      end
    end
    context 'when scraff type clearance discount is greater than $2' do
      it "should set the price_sold as 75% of the wholesale_price" do
        item.style.wholesale_price = 22
        item.style.type = 'Scarf'
        item.save!
        item.clearance!
        expect(item.price_sold).to eq(item.style.wholesale_price.to_d * "0.75".to_d)
      end
    end

    context 'when scraff type clearance discount is less than $2' do
      it "should set the price_sold to $2" do
        item.style.wholesale_price = 2
        item.style.type = 'Scarf'
        item.save!
        item.clearance!
        expect(item.price_sold).to eq(2.to_d)
      end
    end
  end
end
