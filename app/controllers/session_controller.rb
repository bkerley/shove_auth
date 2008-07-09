class SessionController < ApplicationController
  def create
    n = Nonce.create
    respond_to do |wants|
      wants.json { render :json=>n.to_json }
      wants.xml { render :xml=>n.to_xml }
    end
  end

  def update
  end

  def show
    n = Nonce.find_by_sid(params[:id])
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
