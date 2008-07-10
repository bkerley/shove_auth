class UserController < ApplicationController
  def create
  end

  def update
  end

  def show
    user = Account.find_by_username params[:id]
    
    respond_to do |wants|
      wants.xml {  render :xml=>user.to_xml }
      wants.json { render :json=>user.to_json }
    end
  end

  def destroy
  end

end
