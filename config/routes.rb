Rails.application.routes.draw do
  devise_for :users
  
 resources :users
  resources :goals do
    # get :achieved, on: :collection
    get '/achieved' => 'goals#achieved', as: 'achieved'
    get '/failed' => 'goals#failed', as: 'failed'
  resource :comments, only:[:create, :destroy]
  resource :progresses, only:[:create, :destroy]
  resource :rates, only:[:create, :destroy]
  end
  get 'tops/top'
  get 'tops/about'
  root 'tops#top'
  get '/about', to: 'tops#about'
  # get 'goals/achieved', to: 'goals#achieved', as: 'achieved'
  get 'goals/failed', as: 'failed'
end
