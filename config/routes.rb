Rails.application.routes.draw do
  get 'rooms/index'
  get 'rooms/show'
  resources :genres
  resources :scenes
  get 'user/keyword/search', to: 'users#keyword_search'
  get 'tourist_spot/keyword/search', to: 'tourist_spots#keyword_search'
  get 'tourist_spot/genre/search', to: 'tourist_spots#genre_search'
  get 'tourist_spot/scene/search', to: 'tourist_spots#scene_search'
  get 'tourist_spot/prefecture/search', to: 'tourist_spots#prefecture_search'
  get 'tourist_spot/tag/search', to: 'tourist_spots#tag_search'
  post 'follow/:id', to: 'relationships#follow', as: 'follow'
  post 'unfollow/:id', to: 'relationships#unfollow', as: 'unfollow'




  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: "users/sessions",
  }
  
  resources :users
  resources :messages, only: [:create, :destroy]
  resources :rooms, only: [:create, :show, :index]

  resources :tourist_spots do
    resource :favorites, only: [:create, :destroy]
    resource :wents, only: [:create, :destroy]
    resources :reviews do
      resource :likes, only: [:index, :create, :destroy]
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    get 'map', to: 'tourist_spots#map'
  end
  root 'homes#top'
end
