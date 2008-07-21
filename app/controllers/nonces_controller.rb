class NoncesController < ApplicationController
  before_filter :require_admin
  protect_from_forgery
  # GET /nonces
  # GET /nonces.xml
  def index
    @nonces = Nonce.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nonces }
    end
  end

  # DELETE /nonces/1
  # DELETE /nonces/1.xml
  def destroy
    @nonce = Nonce.find(params[:id])
    @nonce.destroy

    respond_to do |format|
      format.html { redirect_to(nonces_url) }
      format.xml  { head :ok }
    end
  end
end
