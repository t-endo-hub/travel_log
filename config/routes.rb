Rails.application.routes.draw do
  resources :genres
  resources :scenes
  get 'tourist_spot/keyword/search', to: 'tourist_spots#keyword_search'
  get 'tourist_spot/genre/search', to: 'tourist_spots#genre_search'
  get 'tourist_spot/scene/search', to: 'tourist_spots#scene_search'
  get 'tourist_spot/prefecture/search', to: 'tourist_spots#prefecture_search'
  get 'tourist_spot/tag/search', to: 'tourist_spots#tag_search'



  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: "users/sessions",
  }
  
  resources :users
  resources :tourist_spots do
    resources :wents, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    resources :reviews do
      resource :likes, only: [:index, :create, :destroy]
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    get 'map', to: 'tourist_spots#map'
  end
  root 'homes#top'
end
