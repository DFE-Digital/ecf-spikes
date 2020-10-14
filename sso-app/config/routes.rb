Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  get :dashboard, to: 'dashboard#index'
  get 'sso', to: 'single_sign_on#index'
  get 'sso/verify', controller: 'single_sign_on', action: 'verify'
  passwordless_for :users
end
