class UserController < ApplicationController
  before_filter :check_username
  
  def create
  end

  def update
  end

  def show
    username = params[:id]
    verify("GET /user/#{username} %s") or return
    
    user = Account.find_by_username username
    
    respond_to do |wants|
      wants.xml {  render :xml=>user.to_xml }
      wants.json { render :json=>user.to_json }
    end
  end

  def destroy
  end
  
  private
  def verify(content)
    sid = params[:session][:sid]
    verifier = content.printf(sid)
    hmac = params[:session][:hmac]
    session_secret = Nonce.find_by_sid(sid).session_secret
    
    check = hmac(session_secret, verifier)
    
    return true if check == hmac
    
    render :text=>'403 Forbidden', :status=>403
    return false
  rescue
    render :text=>'403 Forbidden', :status=>403
    return false
  end
  
  def check_username
    username = params[:username]
    return fail_403 unless username
    @user = Account.find_by_username username
    return fail_403 unless @user
  end
  
  def fail_403
    render :text=>'403 Forbidden', :status=>403
    return false
  end
end
