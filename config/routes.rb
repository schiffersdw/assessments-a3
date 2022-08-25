# frozen_string_literal: true

Rails.application.routes.draw do

  post '/auth/login', to: 'auth#login'

  resources :users, param: :_username
  resources :emitters, param: :_id
  resources :receivers , param: :_id
  resources :invoices , param: :_uuid

  get '/*a', to: 'application#not_found'
  
end
