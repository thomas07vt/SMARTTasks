Smartgoals::Application.routes.draw do

  namespace :api, defaults: {format: 'json'} do 
    namespace :v1 do
      resources :lists, only: [:index, :show, :destroy, :update]
      post "lists/create" => "lists#create", as: 'create_list'
      resources :todos, only: [:update]
      post "todos/create" => "todos#create", as: 'create_todo'

      resources :users, only: [:index]
      post "users/create" => "users#create", as: 'create_user'
      #devise_for :users, :path_prefix => 'api/v1'
    end
  end

  get "home/index"
  get "home/about"
  devise_for :users
  resources :users, only: [:show, :update] do
    resources :lists do
      resources :todos, only: [:create, :destroy, :new, :update]
    end
  end
  root :to => "home#index"
  get 'about' => "home#about"
end
