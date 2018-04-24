Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: "users/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html




     root "posts#index"

     resources :posts do
       resources :comments, only: [:create, :edit, :update, :destroy]
       member do
         post :like
         post :unlike
       end
        collection do
          get :feeds

       end
     end


      resources :users, only: [:show, :new, :create, :edit, :update, :destroy] do
        member do
          get :profile
        end
      end

      resources :friendships, only: [:create, :destroy] do
        member do
          post :confirm
          delete :reject
        end
     end


      resources :categories, only: :show



     namespace :admin do
       resources :categories
       resources :users, only: [:index] do
         member do
          post :update
         end
      end
       resources :posts, only: [:index, :destroy]
       root "categories#index"
     end

end
