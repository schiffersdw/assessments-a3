# frozen_string_literal: true

Rails.application.routes.draw do

  resources :users, param: :_username
  post '/auth/login', to: 'auth#login'
  get '/*a', to: 'application#not_found'
  
end
