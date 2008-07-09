ActionController::Routing::Routes.draw do |map|
  map.resources :session
  map.resources :user
  map.resources :nonces
  map.resources :accounts
  
  map.error '*url', :controller=>'session', :action=>'nil'
end
