Rails.application.routes.draw do
  get '/leaderboard', to: 'batting_statistics#index'
  resources :players
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
