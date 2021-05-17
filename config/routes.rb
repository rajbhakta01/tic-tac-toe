Rails.application.routes.draw do
  root to: "home#index"
  get "home/move"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
end
