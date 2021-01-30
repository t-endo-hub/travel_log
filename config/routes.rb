Rails.application.routes.draw do
	root 'homes#top'
	post '/homes/guest_sign_in', to: 'homes#new_guest'
	get 'get_genre/new', to: 'homes#new', defaults: { format: 'json' }

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: "users/sessions",
  }

  namespace :user do
    resources :tourist_spots, only: [:new, :create, :show, :edit, :update, :destroy] do
      resource :favorites, only: [:create, :destroy]
      resource :wents, only: [:create, :destroy]
      resources :reviews do
        resource :likes, only: [:index, :create, :destroy]
        resources :comments, only: [:create, :edit, :update, :destroy]
      end
      get 'map', to: 'tourist_spots#map'
      get 'images', to: 'tourist_spots#images'
      put :sort
    end

    resources :users, only: [:show, :edit, :update, :destroy]
    resources :messages, only: [:create, :destroy]
    resources :rooms, only: [:create, :show, :index]
    resources :notifications, only: [:index, :destroy]
    resources :coupons, only: [:create, :index]

    get 'user/keyword/search', to: 'users#keyword_search'
    post 'follow/:id', to: 'relationships#follow', as: 'follow'
    post 'unfollow/:id', to: 'relationships#unfollow', as: 'unfollow'
    get 'users/following/:user_id', to: 'users#following', as:'following'
    get 'users/follower/:user_id', to: 'users#follower', as:'follower'

    get 'favorites', to: 'tourist_spots#favorites'
    get 'wents', to: 'tourist_spots#wents'
    get 'tourist_spot/keyword/search', to: 'tourist_spots#keyword_search'
    get 'tourist_spot/genre/search', to: 'tourist_spots#genre_search'
    get 'tourist_spot/scene/search', to: 'tourist_spots#scene_search'
    get 'tourist_spot/prefecture/search', to: 'tourist_spots#prefecture_search'
    get 'tourist_spot/tag/search', to: 'tourist_spots#tag_search'

    get 'get_genre/children', to: 'tourist_spots#get_genre_children', defaults: { format: 'json' }
    get 'get_genre/grandchildren', to: 'tourist_spots#get_genre_grandchildren', defaults: { format: 'json' }
  end
end