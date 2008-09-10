ActionController::Routing::Routes.draw do |map|
  map.resources :aclparts

  map.resources :memberships, :collection=>{:groups=>:get}

  map.resources :session
  map.resources :user
  map.resources :nonces
  map.resources :accounts
  map.resources :admin
  
  map.resources :access
  map.user_creation '/user/:id.:format', :controller=>'user', :action=>'create', :conditions=>{:method=>:post}
  
  map.error '*url', :controller=>'session', :action=>'nil'
end
