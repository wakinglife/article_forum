Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  devise_for :users

     root "articles#index"

     resources :articles, only: [:index, :create, :show, :edit, :update, :destroy] do
       resources :comments, only: [:index,:create, :edit, :update, :destroy]
       member do
         post :like
         post :unlike
       end
        collection do
          get :feeds
          get :ranking
       end
     end


      resources :users, only: [:index, :show, :edit, :update, :destroy] do
        member do
          # get :articles
          # get :likes
          # get :comments
          #
          # get :friends
          # get :inversefriends
          get :friend_list

        end
      end

      resources :friendships, only: [:create, :destroy]
      resources :likes, only: [:create, :destroy]
      resources :comments, only: [:create, :edit, :destroy]
      resources :categories, only: :show


     namespace :admin do
       resources :forums, only: [:index, :destroy]
       resources :categoties, only: [:index, :create, :show, :edit, :update, :destroy]
       resources :users, only: [:index]
       root "articles#index"
     end

end
