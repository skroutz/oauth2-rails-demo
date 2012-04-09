Oauth2Demo::Application.routes.draw do
  post "authorization/authorize"
  get "authorization/callback"
end
