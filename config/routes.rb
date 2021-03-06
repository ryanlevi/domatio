Domatio::Application.routes.draw do
  # The Home Page
  get "home/index"
  # root :to => 'home#index'
  root :to => 'home#index'

  # The Contact Us Page
  get 'home/contact'
  post 'home/contact_post'
  match '/contact' => 'home#contact'

  # The About Page
  get "home/about"
  match '/about' => 'home#about'

  # The FAQ Page
  get "home/faq"
  match '/faq' => 'home#faq'

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
  
  # The Settings Page
  get "users/edit"
  post "users/update"
  delete 'users/destroy/:id', to: 'users#destroy', as: 'destroy'
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
  post 'bills/create'
  get 'bills/past_bills'
  put '/bills/stash/:id', to: 'bills#stash', as: 'stash'
  put '/bills/unstash/:id', to: 'bills#unstash', as: 'unstash'
  put '/bills/mark_as_paid/:id/:user', to: 'bills#mark_as_paid', as: 'mark_as_paid'
  put '/bills/mark_as_unpaid/:id/:user', to: 'bills#mark_as_unpaid', as: 'mark_as_unpaid'
  resources :bills

  #The Chore Pages

  #get "chore/index", to: 'chore#index', as 'chore'
  #put '/chore/prepareEdit/:id', to: 'chore#prepareEdit'
  #get '/chore/edit'
  #post '/chore/update'
  #get "chore/new"
  #post "chore/create"
  resources :chore

  # The Discussion Page
  get 'discussion/', to: 'discussion#list'
  get '/discussion/destroy/:id', to: 'discussion#destroy', as: 'discussion'
  get "discussion/new"
  post 'discussion/create', to: 'discussion#create'
  get '/discussion/:id', to: 'discussion#show', as: 'discussion'
  resources :discussion

  get 'discussion_message/', to: 'discussionMessage#list'
  get '/discussion_message/destroy/:id', to: 'discussion_message#destroy', as: 'discussion_message'
  get 'discussion_message/new/:discussion_id', to: 'discussion_message#new', as: 'discussion_message'
  post 'discussion_message/create_inline', to: 'discussion_message#create_inline'
  resources :discussion_message



  
end
