class UserController < ApplicationController
  before_filter :dehash_params
  before_filter :check_username, :except=>[:create]
  before_filter :check_sid
  
  def create
    return fail_403 unless @nonce.account.admin
    @username = params[:id]
    return fail_403 unless @username
    return fail_403 unless verify_hmac("POST /user/#{@username} %s")
    
    @user = Account.find_by_username @username
    if @user
      render :text=>'405 Method Not Allowed', :status=>405
      return false
    end
    
    @account = Account.new(:username=>@username)
    respond_to do |format|
      if @account.save
        format.xml  { head :created }
        format.json { head :created }
      else
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
        format.json { render :json=> @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    return fail_403 unless @nonce.account.admin || (@nonce.account.username == @username)
    password = params[:password]
    return fail_403 unless verify_hmac("PUT /user/#{@username} %s #{password}")
    
    @user.password = password
    @user.save
    
    respond_to do |wants|
      wants.xml { head :ok }
      wants.json { head :ok }
    end
  end

  def show
    return fail_403 unless verify_hmac("GET /user/#{@username} %s")
    
    respond_to do |wants|
      wants.xml {  render :xml=>@user.to_xml }
      wants.json { render :json=>@user.to_json }
    end
  end

  def destroy
    return fail_403 unless verify_hmac("DELETE /user/#{params[:id]} %s")
    
    u = Account.find_by_username params[:id]
    u.destroy
    
    respond_to do |wants|
      wants.xml { head :ok }
      wants.json { head :ok }
    end
  end
  
  private
  def verify_hmac(content)
    sid = params[:session][:sid]
    verifier = sprintf(content, sid)
    hmac = params[:session][:hmac]
    session_secret = Nonce.find_by_sid(sid).session_secret
    
    check = Nonce.hmac(session_secret, verifier)
    
    return true if check == hmac
    
    return false
  rescue
    return false
  end
  
  def check_sid
    return fail_403 unless params[:session] and params[:session][:sid]
    @nonce = Nonce.find_by_sid(params[:session][:sid])
    return fail_403 unless @nonce
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
  
  def dehash_params
    return true unless params[:hash]
    params[:hash].each {|k,v| params[k] = v}
  end
end
