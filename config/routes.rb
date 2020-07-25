require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]



Rails.application.routes.draw do
    
  root to: 'pages#landing'
  get "enqueue-jobs", to:"pages#enqueue_jobs" 
    
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
  resources :pages, :defaults => { :format => :json }
  
  
end
