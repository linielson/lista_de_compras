Rails.application.routes.draw do
  namespace :api do
    resources :lists
    resources :products, except: [:new, :edit]
  end
end
