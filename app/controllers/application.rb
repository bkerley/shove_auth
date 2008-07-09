# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # only protect the html-bound controllers
  # protect_from_forgery # :secret => '8f56c26399c51a9bd5c7e7ade0e7883b'
  
  filter_parameter_logging :password
end
