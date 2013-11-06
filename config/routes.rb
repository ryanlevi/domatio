Domatio::Application.routes.draw do

  # The Home Page
  get "home/index"
  # root :to => 'home#index'
  root :to => 'home#index'

  # The About Page
  get "home/about"
  match '/about' => 'home#about'

  # Error pages
  get "errors/e404"
  get "errors/e422"
  get "errors/e500"
  match '404' => 'errors#e404'
  match '422' => 'errors#e422'
  match '500' => 'errors#e500'

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
  get "groups/index"
  get "groups/new"
  post "groups/leave"
  resources :groups

  # The Bills page
  resources :bills
  post 'bills/create'

  # The Discussion Page
  get 'discussion/', to: 'discussion#list'
  get "discussion/new"
  post 'discussion/create', to: 'discussion#create'
  get '/discussion/:id', to: 'discussion#show', as: 'discussion'
  resources :discussion

  get 'discussion_message/', to: 'discussionMessage#list'
  get 'discussion_message/new/:discussion_id', to: 'discussion_message#new', as: 'discussion_message'
  post 'discussion_message/create_inline', to: 'discussion_message#create_inline'
  resources :discussion_message

end
