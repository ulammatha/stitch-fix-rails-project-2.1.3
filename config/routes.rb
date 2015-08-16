Rails.application.routes.draw do
  resources :clearance_batches, only: [:index, :create] do
    collection do
      get :report
    end
  end
  root to: "clearance_batches#index"
end
