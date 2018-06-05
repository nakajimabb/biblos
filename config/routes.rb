Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin20520720', as: 'rails_admin'
  devise_for :users, module: :users
  root 'bibles#index'

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
end
