Rails.application.routes.draw do
  devise_for :users
  
 resources :users do
  get :trying_list, on: :member
  get :achieved_list, on: :member
  get :failed_list, on: :member
  resources :goals, :except => :index do
    # get '/achieved' => 'goals#achieved', as: 'achieved'
    # get '/failed' => 'goals#failed', as: 'failed'
    get :achieved, on: :member
    get :failed, on: :member
    resource :comments, only:[:create, :destroy]
    resource :progresses, only:[:create, :destroy]
    resource :rates, only:[:create, :destroy]
  end
end

get '/goals', to: 'goals#index', as: 'goals'
# get '/user/:id/edit', to: 'goals#index', as: 'goals'
get 'tops/top'
get 'tops/about'
root "tops#top"
get '/about', to: 'tops#about'
end