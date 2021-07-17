# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :graphs
  resources :nodes
  resources :edges
  resources :categories
  resources :paths
end
