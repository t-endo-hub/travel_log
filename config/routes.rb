Rails.application.routes.draw do
  get 'coupons/index'
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
  get 'users/following/:user_id', to: 'users#following', as:'following'
  get 'users/follower/:user_id', to: 'users#follower', as:'follower'
  get 'get_genre/new', to: 'homes#new', defaults: { format: 'json' }
  

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: "users/sessions",
  }
  
  resources :users
  resources :messages, only: [:create, :destroy]
  resources :rooms, only: [:create, :show, :index]
  resources :coupons, only: [:create, :index]


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

  get 'get_genre/children', to: 'tourist_spots#get_genre_children', defaults: { format: 'json' }
  get 'get_genre/grandchildren', to: 'tourist_spots#get_genre_grandchildren', defaults: { format: 'json' }

end
