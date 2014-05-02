Smartgoals::Application.routes.draw do
  get "home/index"
  get "home/about"
  devise_for :users
  resources :users, only: [:show, :update] do
    resources :lists
  end
  root :to => "home#index"
  get 'about' => "home#about"
end
