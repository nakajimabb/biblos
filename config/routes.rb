Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin20520720', as: 'rails_admin'
  devise_for :users, module: :users
  root 'bibles#index'

  get 'bibles/import_sword'
  post 'bibles/import_sword_exec', to: 'bibles#import_sword_exec'
  get 'bibles/sword'
  resources :bibles, :only => [:index]
end
