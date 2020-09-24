Rails.application.routes.draw do
  
  get 'password_resets/new'
  get 'password_resets/edit'
  root   'home_pages#top'
  get    'sessions/new'
  get    '/about',                 to: 'home_pages#about'
  get    '/signup',                to: 'users#new'
  get    '/login',                 to: 'sessions#new'
  post   '/login',                 to: 'sessions#create'
  delete '/logout',                to: 'sessions#destroy'
  post    'posts/:post_id/likes',  to: 'likes#create'
  delete  'posts/:post_id/likes',  to: 'likes#destroy'
  get   'users/:id/likes',         to: 'users#likes'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :posts,               only: [:new, :index, :show, :create, :destroy]
  resources :relationships,       only: [:create, :destroy]

end
