Rails.application.routes.draw do
  
  root   'home_pages#top'
  get    'sessions/new'
  get    '/about',  to: 'home_pages#about'
  get    '/signup', to: 'users#new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]

end
