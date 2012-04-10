Oauth2Demo::Application.routes.draw do
  post "authorization/authorize"
  get "authorization/callback"

  # Default site root
  root :to => "home#index"
end
