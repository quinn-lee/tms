Rails.application.routes.draw do
  get "pages/home"
  root "pages#home"

  resources :sessions
  delete '/logout' => 'sessions#destroy', as: :logout
  resources :users do
    collection do
      get :edit_password
      post :change_password

      get :new_driver
      get :drivers
      post :create_driver

      get :new_customer
      get :customers
      post :create_customer
    end
  end

  resources :transport_orders do
    collection do
      get :staff_views
      get :new_pickup_order
      post :create_return
      get :returns
    end
    member do
      get :route_plan
      post :route_planed

      get :arrived

      get :new_return
    end
  end

  resources :branches

  resources :trucks do
    member do
      get :bound_drivers
      post :binding_driver
      get :unbind_driver
    end
  end

  resources :order_routes

  resources :transport_tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :mobile do
    get "pages/profile"
    post "pages/checkin"
    resources :transport_tasks do
      member do
        post :start
        post :finish
      end
      collection do
        get :in_progress_orders
      end
    end
    resources :order_routes do
      member do
        post :picked
        post :loaded
        post :sent
        post :finished
        post :rearranged
      end
    end
  end
end
