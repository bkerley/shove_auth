class SessionController < ApplicationController
  def create
    n = Nonce.create
    headers[:location] = "/session/#{n.sid}"
    respond_to do |wants|
      wants.json { render :json=>n.to_json }
      wants.xml { render :xml=>n.to_xml }
    end
  end

  def update
    
    user = Nonce.load_user(params[:id], params[:username], params[:hmac])
    
    unless user
      render(:text=>'400 Bad Request', :status=>403)
      return
    end
    
    
  end

  def show
    sid = params[:id]
    
    n = Nonce.find_by_sid(sid)
    
    expected_hmac = hmac(n.session_secret, '')
    if n.nil?
      render(:text=>'404 Not Found', :status=>404) 
      return
    end
    
    if n.state == :not_authenticated
      render(:text=>'403 Forbidden', :status=>403)
      return
    end
    
    
    respond_to do |wants|
      wants.json { render :json=>n.to_json }
      wants.xml { render :xml=>n.to_xml }
    end
  end

end
