Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  

  resources :comments, only: [:create]
  resources :doubts, only: [:new, :index, :create]
  
  get '/', to: 'users#login_form'

  scope :doubts do
    get '/', to: 'doubts#index'
    get '/:id/solve', to: 'doubts#accept'
    patch '/:id/solve', to: 'doubts#resolve'
    post '/:id/escalate', to: 'doubts#escalate'
    get '/stats', to: 'doubts#stats'
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
