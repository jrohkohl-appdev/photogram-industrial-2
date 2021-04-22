Rails.application.routes.draw do
  
  root "photos#index"

  
  
  devise_for :users
  
  resources :comments
  resources :follow_requests
  resources :likes
  resources :photos
  


  get ":username/liked" => "photos#liked", as: :liked_photos
  get ":username/feed" => "users#feed", as: :user_feed
  get ":username/followers" => "follow_requests#followers", as: :followers
  get ":username/following" => "follow_requests#follows", as: :follows




  get ":username" => "users#show", as: :user


end
