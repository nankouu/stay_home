Rails.application.routes.draw do
  namespace :admin do
    get 'posts/index'
    get 'posts/show'
  end
  namespace :admin do
    get 'users/index'
    get 'users/show'
  end
  root 'user/posts#index'

  namespace :admin do
  	resources :users, only: [:index, :show, :edit, :update, :destroy]
  	resources :posts, only: [:index, :show, :edit, :destroy]
  	resources :genres, only: [:index, :create, :destroy]
  	root 'home#index'
  end

  namespace :user do
    resources :users
  	resources :posts do
       resources :comments, only: [:create, :destroy]
  	   resource :favorites, only: [:create, :destroy]
     end
  	post 'follow/:id' => 'relationships#follow', as: 'follow' # フォローする
  	post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  end

  devise_for :admins, controllers: {
    sessions:      'admin/admins/sessions',
    passwords:     'admin/admins/passwords',
    registrations: 'admin/admins/registrations'
  }
  devise_for :users, controllers: {
    sessions:      'user/users/sessions',
    passwords:     'user/users/passwords',
    registrations: 'user/users/registrations'
  }


Refile.secret_key = '84d656a3f884f325accbb721f8094ab5f7e7b3408d3f519c17a2093ad98ba62782a3f5d33fa0798131e86476ebdeb5c9c8c170b7ff33f7f61b4c0f59cf0a0506'
end
