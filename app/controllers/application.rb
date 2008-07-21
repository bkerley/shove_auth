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
end
