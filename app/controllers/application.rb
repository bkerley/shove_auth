# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  layout 'scaffold'
  
  filter_parameter_logging :password
  
  def hmac(secret, message)
    Nonce.hmac(secret, message)
  end
  
  def method_missing(methodname, *args)
   render :text=>'404 Not Found', :status=>404
  end
  
  def require_login
    unless session[:account]
      redirect_to new_admin_path
    end
  end
  
  def require_admin
    unless session[:account] && Account.find(session[:account]).admin
      flash[:notice] = "You're not allowed to do that."
      redirect_to admin_path(session[:account])
    end
  end
end
