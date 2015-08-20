require 'rails_helper'

RSpec.describe ClearanceBatchesController, type: :controller do

  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET report" do
    let!(:clearance_batch) { FactoryGirl.create(:clearance_batch) }
    it "should return clearanced batch " do
      get :report, clearance_id: clearance_batch.id
      expect(assigns(:clearanced_batch).id).to eq(clearance_batch.id)
    end
  end

  describe "GET add_clearance_item" do
    context 'when item is invalid' do
      it "should not add item in to clearance batch" do
        get :add_clearance_item, item_id: 0
        expect(assigns(:item)).to be_nil
      end
    end

    context 'when item is valid and sellable status' do
      let!(:item) {FactoryGirl.create(:item)}
      it "should add item in to clearance batch" do
        get :add_clearance_item, item_id: item.id
        expect(assigns(:item).id).to eq(item.id)
        expect(session[:clearance_items][0]).to eq(item.id)
      end
    end

    context 'when item is valid but in clearanced status' do
      let!(:item) {FactoryGirl.create(:item, status: Item::STATUS[:clearanced])}
      it "should not add item in to clearance batch" do
        get :add_clearance_item, item_id: item.id
        expect(session[:clearance_items]).to be_nil
      end
    end
  end

  describe "POST create" do
    context 'when no items for clearance' do
      it "should return no items exists error message" do
        session[:clearance_items] = nil
        post :create
        expect(flash[:notice]).to match("No Item exists for clearance")
      end
    end

    context 'when vaid clearance items' do
      let!(:items) { FactoryGirl.create_list(:item, 5) }
      it "should return successful message" do
        session[:clearance_items] = items.map(&:id)
        post :create
        expect(flash[:notice]).to match("items clearanced in batch")
      end
    end

    context 'when invalid clearance items' do
      let!(:items) { FactoryGirl.create_list(:item, 5) }
      it "should return successful message" do
        session[:clearance_items] = ["test", 9999, 0, "", "_"]
        post :create
        expect(flash[:notice]).to match("No new clearance batch was added")
      end
    end
  end
end
