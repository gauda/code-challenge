Rails.application.routes.draw do
  resource :signup, only: %i[create]
  resources :authentications, only: %i[create]
  resources :users, only: %i[index destroy] do
    resource :archive, only: %i[create destroy]
  end
end
