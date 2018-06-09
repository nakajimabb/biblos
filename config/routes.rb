Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin20520720', as: 'rails_admin'
  root 'bibles#index'

  get '/users/edit_profile'
  patch '/users/update_profile', to: 'users#update_profile'
  post '/users/update_used_bibles', to: 'users#update_used_bibles'
  devise_for :users, module: :users

  get 'bibles/size_info'
  get 'bibles/import_sword'
  post 'bibles/import_sword_exec', to: 'bibles#import_sword_exec'
  get 'bibles/sword'
  resources :bibles, :only => [:index]

  get 'dictionaries/get'
  get 'dictionaries/import_vocab'
  post 'dictionaries/load_vocab', to: 'dictionaries#load_vocab'

  get 'morphologies/get'
  get 'morphologies/import'
  post 'morphologies/load', to: 'morphologies#load'
  get 'morphologies/import_oshm'
  post 'morphologies/load_oshm', to: 'morphologies#load_oshm'

  get '/vocab_indices/scan'
  post '/vocab_indices/scan_exec', to: 'vocab_indices#scan_exec'

  get '/audio_segments/import'
  post '/audio_segments/load', to: 'audio_segments#load'
  get '/audio_segments/edit'
  post '/audio_segments/regist', to: 'audio_segments#regist'
  resources :audio_segments, :only => [:destroy]
end
