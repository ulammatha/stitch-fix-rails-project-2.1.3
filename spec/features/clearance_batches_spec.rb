require "rails_helper"
require 'rack_session_access/capybara'

describe "add new monthly clearance_batch" do

  describe "clearance_batches index", type: :feature do

    describe "see previous clearance batches" do

      let!(:clearance_batch_1) { FactoryGirl.create(:clearance_batch) }
      let!(:clearance_batch_2) { FactoryGirl.create(:clearance_batch) }

      it "displays a list of all past clearance batches" do
        visit "/"
        expect(page).to have_content("Stitch Fix Clearance Tool")
        expect(page).to have_content("Clearanced Batches")
        within('table.clearance_batches') do
          expect(page).to have_content("#{clearance_batch_1.id}")
          expect(page).to have_content("#{clearance_batch_2.id}")
          expect(page).to have_content("Report")
        end
      end
    end

    describe "add a new item to clearance batch" do
      it "should allow to add valid item to clearance batch" do
        item = FactoryGirl.create(:item)
        visit "/"
        fill_in 'item_id', :with => item.id
        click_button "Add Item"
        expect(page).not_to have_content("Item not found, Please check the Item id")
        expect(page).not_to have_content("Item could not be clearanced")
        expect(page).to have_content('Remove')
        expect(page).to have_content("#{item.id}")
      end

      it "should not allow to add item whose status is clearanced" do
        item = FactoryGirl.create(:item, status: Item::STATUS[:clearanced])
        visit "/"
        fill_in 'item_id', :with => item.id
        click_button "Add Item"
        expect(page).not_to have_content("Item not found, Please check the Item id")
        expect(page).to have_content("Item could not be clearanced")
      end

      it "should not allow to add invalid item " do
        visit "/"
        fill_in 'item_id', :with => "test_id"
        click_button "Add Item"
        expect(page).not_to have_content("Item could not be clearanced")
        expect(page).to have_content("Item not found, Please check the Item id")
      end
    end

    describe "create clearance batch" do
      context "successful clearance batch" do
        it "should create a clearance batch" do
          items = FactoryGirl.create_list(:item, 2)
          page.set_rack_session(clearance_items: items.map(&:id))
          visit "/"
          click_button "Clearance"
          new_batch = ClearanceBatch.first
          expect(page).to have_content("#{items.count} items clearanced in batch #{new_batch.id}")
          expect(page).not_to have_content("No new clearance batch was added")
          expect(page).not_to have_content("No Item exists for clearance")
          within('table.clearance_batches') do
            expect(page).to have_content("#{new_batch.id}")
          end
        end
      end

      context "failed to clearance batch" do
        it "should not create a clearance batch for invalid items" do
          page.set_rack_session(clearance_items: ["invalid_item"])
          visit "/"
          click_button "Clearance"
          expect(page).not_to have_content("items clearanced in batch")
          expect(page).to have_content("No new clearance batch was added")
          expect(page).not_to have_content("No Item exists for clearance")
        end
      end

      context "failed to clearance batch" do
        it "should not create a clearance batch for empty items" do
          visit "/"
          click_button "Clearance"
          expect(page).not_to have_content("items clearanced in batch")
          expect(page).not_to have_content("No new clearance batch was added")
          expect(page).to have_content("No Item exists for clearance")
        end
      end
    end
  end
end

