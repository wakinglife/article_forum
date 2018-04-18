Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  # devise_for :users

     root "posts#index"

     resources :psots, only: [:index, :create, :show, :edit, :update, :destroy] do
       resources :comments, only: [:index, :create, :edit, :update, :destroy]
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

          get :friend_list

        end
      end

      resources :friendships, only: [:create, :destroy] do
        member do
          post :confirm
          delete :reject

        end
     end


      resources :categories, only: :show
      resources :views, only: [:index, :show]


     namespace :admin do
       resources :posts, only: [:index, :destroy]
       resources :categories, only: [:index, :create, :show, :edit, :update, :destroy]
       resources :users, only: [:index]
       root "articles#index"
     end

end
