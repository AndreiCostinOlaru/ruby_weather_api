Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Weather API routes
  get "weather/weekly/:city", to: "weather#weekly_forecast"
  get "weather/cities", to: "weather#cities"
  get "weather/video/:city", to: "weather#city_video"

  # Favorites routes
  get "favorites", to: "favorites#index"
  post "favorites", to: "favorites#create"
  delete "favorites/:city", to: "favorites#destroy"

  # Defines the root path route ("/")
  # root "posts#index"
end
