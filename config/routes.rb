Rails.application.routes.draw do
  root 'customers#index'

  resources :customers, except: :show do
    collection do
      get :blacklist
    end

    member do
      put :add_to_blacklist
      put :destroy_from_blacklist
    end
  end
end
