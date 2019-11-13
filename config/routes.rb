Rails.application.routes.draw do
  devise_for :users
  
  resources :users
  resources :goals do
  resource :commments, only:[:create, :destroy]
  resource :progresses, only:[:create, :destroy]
  resource :rates, only:[:create, :destroy]
  end
  get 'tops/top'
  get 'tops/about'
  root 'tops#top'
  get '/about', to: 'tops#about'
end
