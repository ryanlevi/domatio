Domatio::Application.routes.draw do

  # The Home Page
  get "home/index"
  root :to => 'home#index'

  # The About Page
  get "home/about"
  match '/about' => 'home#about'

  # The Login/Logout/SignUp Pages
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  resources :users
  resources :sessions

  # The Reset passwords page
  resources :password_resets
  get "password_resets/new"

end
