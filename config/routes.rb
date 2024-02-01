Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "feed#show"

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"

  #Session routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # TODO:
  resource :profile, only: [:show, :update], controller: "users"

  namespace :users do
    patch "change_password", to: "passwords#update"
  end

end
