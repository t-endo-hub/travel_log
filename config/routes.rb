Rails.application.routes.draw do
  resources :genres

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: "users/sessions",
  }
  
  resources :users
  resources :tourist_spots do
    resources :wents, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    resources :reviews
  end
  root 'homes#top'
end
