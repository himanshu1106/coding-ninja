Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :doubts, only: [:create, :update]
  
  scope :doubts do
    get '/:id',  to: 'doubts#show'
    get '', to: 'doubts#index'
    patch '/:id/solve', to: 'doubts#resolve'
    get '/stats', to: 'doubts#stats'
  end
  
  
  scope :users do
    post 'login', to: 'users#login'
    patch 'logout', to: 'users#logout'
    get 'home', to: 'users#home'
  end
  resource :users, only: [:index, :show]

  

end
