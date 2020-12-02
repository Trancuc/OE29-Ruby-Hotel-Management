Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers: {
        sessions: 'users/sessions'
    }
    root "static_pages#home"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    # get "/login", to: "sessions#new"
    # post "/login", to: "sessions#create"
    # delete "/logout", to: "sessions#destroy"
    resources :account_activations, only: :edit
    resources :rooms, only: %i(index show) do
      resources :comments, only: %i(create destroy)
    end
    resources :reservations
    resources :users
    resources :bills
    resources :bookings
    resources :rates, only: %i(create update)
    resources :comments, only: %i(create destroy)

    namespace :admin do
      root "dashboard#index"
      get "/bill_history", to: "dashboard#bill_history"
      get "/income_bill", to: "dashboard#income_bill"
      resources :views, except: %i(new show)
      resources :reservations
      resources :users do
        resources :bills do
          resources :bookings
        end
      end
      resources :bookings
      resources :bills
      resources :booking_services
      resources :types, except: %i(new show)
      resources :unities, except: %i(new show)
      resources :services, except: %i(new show)
      resources :rooms, except: :show
    end
  end
  match "*unmatched", to: "application#render_404", via: :all
end
