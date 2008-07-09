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
  end

end
