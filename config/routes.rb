Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  

  resources :comments
  resources :doubts
  
  scope :doubts do
    get '/:id',  to: 'doubts#show'
    get '', to: 'doubts#index'
    patch '/:id/solve', to: 'doubts#resolve'
    get '/stats', to: 'doubts#stats'
    # get '/create_doubt', to: 'douPATCHbts#new_doubt'
  end

  scope :reports  do
    get 'ta_stats', to: 'report#ta_stats'
  end

  
  
  scope :users do
    get 'login', to: 'users#login_form'
    post 'login', to: 'users#login'
    post 'logout', to: 'users#logout'
    get 'home', to: 'users#home'
  end
  

  

end
