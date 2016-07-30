Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  get 'welcome/index'
  get 'faq', to: 'faq#index'

  resources :tax_returns


  # AJAX / API
  get 'visits/new', to: 'visits#new'
  post 'visits/import', to: 'visits#import'
  get 'visits/import_result/:job_id', to: 'visits#import_result', as: 'import_result'

end
