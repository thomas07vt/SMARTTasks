Smartgoals::Application.routes.draw do
  get "home/index"
  get "home/about"
  devise_for :users
  root :to => "home#index"
  get 'about' => "home#about"
end
