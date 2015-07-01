Rails.application.routes.draw do
  namespace :api do
    resources :lists
    resources :products
  end
end
