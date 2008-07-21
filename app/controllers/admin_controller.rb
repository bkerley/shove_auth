class AdminController < ApplicationController
  before_filter :require_login, :except=>[:new, :create]
  def new
  end
  
  def index
    redirect_to admin_path(session[:account])
    return
  end
  
  def show
    @u = Account.find(session[:account])
  end

  def destroy
    reset_session
    redirect_to new_admin_path
  end

  def create
    if session[:account]
      redirect_to admin_path(session[:account])
      return
    end
    
    u = Account.find_by_username(params[:admin][:username])
    r = u.check_password(params[:admin][:password]) rescue false
    
    unless r
      flash[:notice] = "Incorrect login"
      redirect_to new_admin_path and return
    end
    
    flash[:notice] = "Logged in as #{u.username}"
    session[:account] = u.id
    redirect_to admin_path(session[:account])
  end
end
