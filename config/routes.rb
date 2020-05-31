Rails.application.routes.draw do
  root 'user/posts#index'

  post '/homes/guest_sign_in', to: 'homes#new_guest'

  devise_scope :user do
    post 'users/guest_sign_in', to: 'user/users/sessions#new_guest'
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      collection do
        get 'search'
      end
    end
    resources :posts, only: [:index, :show, :edit, :destroy]
    resources :genres, only: [:index, :create, :destroy, :edit, :update]
    root 'posts#index'
  end

  namespace :user do
    resources :users, only: [:show, :index, :edit, :update] do
      member do
        get :follows, :followers # フォロー、フォロワーページ
        post :destroy, as: 'destroy'
      end
      collection do
        get 'search'
      end
    end
    resources :posts do
      resources :comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      collection do
        get 'search'
        get "following_posts"
      end
    end
    post 'follow/:id' => 'relations#follow', as: 'follow' # フォローする
    post 'unfollow/:id' => 'relations#unfollow', as: 'unfollow' # フォローを外す
    resources :rooms, only: [:create, :show, :index]
    resources :messages, only: [:create]
    get 'tags/:tag', to: 'posts#index', as: :tag

    resources :favorites, only: [:index] # お気に入り機能
  end

  devise_for :admins, controllers: {
    sessions: 'admin/admins/sessions',
    passwords: 'admin/admins/passwords',
    registrations: 'admin/admins/registrations',
  }
  devise_for :users, controllers: {
    sessions: 'user/users/sessions',
    passwords: 'user/users/passwords',
    registrations: 'user/users/registrations',
    omniauth_callbacks: 'user/users/omniauth_callbacks',
  }

  Refile.secret_key = '84d656a3f884f325accbb721f8094ab5f7e7b3408d3f519c17a2093ad98ba62782a3f5d33fa0798131e86476ebdeb5c9c8c170b7ff33f7f61b4c0f59cf0a0506'
end
