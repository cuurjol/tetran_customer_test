Rails.application.routes.draw do
  root 'customers#index'

  resources :customers, except: :show do
    collection do
      get :blacklist
      post :add_to_blacklist
    end

    member do
      put :ban
      put :unban
    end
  end
end
