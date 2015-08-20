Rails.application.routes.draw do
  root to: "clearance_batches#index"

  resources :clearance_batches, only: [:index, :create] do
    collection do
      get :report
      get :add_clearance_item, as: :add
      get :remove_clearance_item, as: :remove
    end
  end

  resources :items, only: :index
end
