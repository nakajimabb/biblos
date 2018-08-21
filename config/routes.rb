Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin20520720', as: 'rails_admin'
  root 'users#home'

  get '/users/home'
  get '/users/images'
  get '/users/:id/images', to: 'users#images'
  get '/users/image/:attachment_id', to: 'users#image'
  get '/users/:id/image/:attachment_id', to: 'users#image'
  get '/users/edit_profile'
  patch '/users/update_profile', to: 'users#update_profile'
  post '/users/update_used_bibles', to: 'users#update_used_bibles'
  get '/users/invitation'
  post '/users/send_invitation', to: 'users#send_invitation'
  # devise_for :users, module: :users
  devise_for :users, controllers: { invitations: 'users/invitations' }
  resources :users, :only => [:index, :show]

  get '/groups/:id/members', to: 'groups#members'
  resources :groups, :only => [:index, :show]

  get 'bibles/size_info'
  get 'bibles/import_sword'
  post 'bibles/load_sword', to: 'bibles#load_sword'
  get 'bibles/sword'
  get 'bibles/get_bibles'
  get 'bibles/check_sword'
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

  resources :users do
    resources :articles, :only => [:index, :show]
  end
  resources :groups do
    resources :articles, :only => [:index, :show]
  end
  resources :articles

  resources :vocabularies, :only => [:index, :update]

  get '/:group_code', to: 'groups#detail'
end
