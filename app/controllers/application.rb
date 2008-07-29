# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
include HoptoadNotifier::Catcher
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  layout 'scaffold'
  
  filter_parameter_logging :password
  
  def method_missing(methodname, *args)
   render :text=>'404 Not Found', :status=>404
  end
  
  def require_login
    unless session[:account]
      redirect_to new_admin_path, :status=>403
    end
  end
  
  def require_admin
    unless session[:account] && Account.find(session[:account]).admin
      flash[:notice] = "You're not allowed to do that."
      redirect_path = session[:account] ? admin_path(session[:account]) : new_admin_path
      redirect_to redirect_path, :status=>403
    end
  end
end
