Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts
      resources :weather, only: %i[index]
    end
  end
end
