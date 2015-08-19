Rails.application.routes.draw do
  root to: "clearance_batches#index"

  resources :clearance_batches, only: [:index, :create] do
    collection do
      get :report
      get :add_clearance_item, as: :item
    end
  end

  resources :items, only: :index
end
