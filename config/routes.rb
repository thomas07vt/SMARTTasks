Smartgoals::Application.routes.draw do
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
