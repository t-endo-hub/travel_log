Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: "users/sessions",
  }
  resources :tourist_spots do
    resources :wents, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
  end
  root 'homes#top'
end
