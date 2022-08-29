# frozen_string_literal: true

Rails.application.routes.draw do
  post '/auth/login', to: 'auth#login'

  resources :users, param: :_username
  resources :emitters, param: :_id
  resources :receivers, param: :_id
  resources :invoices, param: :_id do
    collection do
      post :massive_upload
      get '/stamp_qr/:_id', to: 'invoices#stamp_qr', as: :stamp_qr
    end
  end

  get '/*a', to: 'application#not_found'
end
