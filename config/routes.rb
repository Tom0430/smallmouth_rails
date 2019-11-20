Rails.application.routes.draw do
  devise_for :users

resources :users do
  get :trying_list, on: :member
  get :achieved_list, on: :member
  get :failed_list, on: :member
  resources :goals, :except => :index do
    get :achieved, on: :member
    get :failed, on: :member
    resource :comment, only:[:create, :destroy]
    resource :progress, only:[:create, :destroy]
    resource :rate, only:[:create, :update]
  end
end

get '/goals', to: 'goals#index', as: 'goals'
get '/ranking', to: 'rates#ranking', as: 'ranking'
get 'tops/top'
get 'tops/about'
root "tops#top"
get '/about', to: 'tops#about'
end