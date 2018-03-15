Rails.application.routes.draw do
  resources :students
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # add our register route:
  post 'auth/register', to: 'users#register'
  post 'auth/login', to: 'users#login'
end
