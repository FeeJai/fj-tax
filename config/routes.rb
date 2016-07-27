Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  get 'welcome/index'

  resources :tax_returns

  get 'visits', to: 'visits#import'
  get 'visits/:id', to: 'visits#results'

end
