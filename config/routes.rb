Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :webhooks do
    namespace :facebook do
      resources :bot, only: [:index, :create]
    end
  end
end
