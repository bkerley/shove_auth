ActionController::Routing::Routes.draw do |map|
  map.resources :session
  map.resources :user
  map.resources :nonces
  map.resources :accounts
  map.resources :admin
  map.user_creation '/user/:id.:format', :controller=>'user', :action=>'create', :conditions=>{:method=>:post}
  
  map.error '*url', :controller=>'session', :action=>'nil'
end
