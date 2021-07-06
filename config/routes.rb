Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :users do
    post 'login', to: 'users#login'
  end
  resource :users, only: [:show]

end
