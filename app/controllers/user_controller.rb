class UserController < ApplicationController
  before_filter :check_username, :except=>[:create]
  
  def create
    @username = params[:username]
    return fail_403 unless @username
    verify_hmac("POST /user/#{@username} %s")
    
  end

  def update
    salt = params[:salt]
    crypted_pw = params[:crypted_pw]
    verify_hmac("PUT /user/#{@username} %s #{salt} #{crypted_pw}")
  end

  def show
    result =  verify_hmac("GET /user/#{@username} %s")
    return false unless result
    
    respond_to do |wants|
      wants.xml {  render :xml=>@user.to_xml }
      wants.json { render :json=>@user.to_json }
    end
  end

  def destroy
  end
  
  private
  def verify_hmac(content)
    sid = params[:session][:sid]
    verifier = sprintf(content, sid)
    hmac = params[:session][:hmac]
    session_secret = Nonce.find_by_sid(sid).session_secret
    
    check = Nonce.hmac(session_secret, verifier)
    return true if check == hmac
    
    return fail_403
  rescue
    return fail_403
  end
  
  def check_username
    @username = params[:id]
    return fail_403 unless @username
    @user = Account.find_by_username @username
    return fail_403 unless @user
    return true
  end
  
  def fail_403
    render :text=>'403 Forbidden', :status=>403
    return false
  end
end
