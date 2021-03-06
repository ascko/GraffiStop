Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  apipie
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  root to: 'static_pages#home'
  match '/signup',  to: 'users#new', :via => :get
  #match '/signin',  to: 'sessions#new', :via => :get
  #match '/signout', to: 'sessions#destroy', via: :delete
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  match '/help',    to: 'static_pages#help', :via => :get
  match '/about',   to: 'static_pages#about', :via => :get
  match '/contact', to: 'static_pages#contact', :via => :get
  resources :locations,          only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
