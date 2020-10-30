Rails.application.routes.draw do
  
  get 'password_resets/new'
  get 'password_resets/edit'
  root   'home_pages#top'
  get    'sessions/new'
  get    '/signup',                to: 'users#new'
  get    '/login',                 to: 'sessions#new'
  post   '/login',                 to: 'sessions#create'
  delete '/logout',                to: 'sessions#destroy'

  get     'users/:id/likes',       to: 'users#likes'
  post    'users/guest_sign_in',  to: 'users#new_guest' 
  get     'posts/ranking',         to: 'posts#ranking'
  resources :posts,               only: [:new, :index, :show, :edit,:update, :create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :posts, only: [:create, :destroy, :show] do
    resources :comments, only: [:create, :destroy]
  end
  resources :posts, only: [:create, :destroy,:index, :show] do
    resources :likes, only: [:create, :destroy]
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]

end
