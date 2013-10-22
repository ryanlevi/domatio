Domatio::Application.routes.draw do

  get "groups/new"

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
  post "groups/add_user_create"
  resources :groups

  # The Discussion Page
  get 'discussion/', to: 'discussion#list'
  get "discussion/new"
  post 'discussion/create', to: 'discussion#create'
  get '/discussion/:id', to: 'discussion#show', as: 'discussion'
  resources :discussion

  get 'discussion_message/', to: 'discussionMessage#list'
  get 'discussion_message/new/:discussion_id', to: 'discussion_message#new', as: 'discussion_message'
  resources :discussion_message

end
