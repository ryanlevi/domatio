Domatio::Application.routes.draw do
  # The Home Page
  get "home/index"
  # root :to => 'home#index'
  root :to => 'users#new'

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

  # The Group Page
  get "groups/add_user"
  get "groups/user_leaves"
  post "groups/add_user_create"
  get "groups/index"
  get "groups/new"
  resources :groups

  # The Bills page
  resources :bills
  post 'bills/create'
  
end
