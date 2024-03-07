Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :blueprint_variants, only: [:create]
      resources :blueprints, only: [:create]
      resources :blueprint_changes, only: [:create]
    end
  end

  resources :blueprints, only: [:index, :show, :edit, :update, :destroy]

  resources :downloads, only: [:index]

  root "blueprints#index"

  # Defines the root path route ("/")
  # root "posts#index"
end
