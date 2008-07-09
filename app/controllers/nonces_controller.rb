class NoncesController < ApplicationController
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

  # GET /nonces/1
  # GET /nonces/1.xml
  def show
    @nonce = Nonce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nonce }
    end
  end

  # GET /nonces/new
  # GET /nonces/new.xml
  def new
    @nonce = Nonce.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nonce }
    end
  end

  # GET /nonces/1/edit
  def edit
    @nonce = Nonce.find(params[:id])
  end

  # POST /nonces
  # POST /nonces.xml
  def create
    @nonce = Nonce.new(params[:nonce])

    respond_to do |format|
      if @nonce.save
        flash[:notice] = 'Nonce was successfully created.'
        format.html { redirect_to(@nonce) }
        format.xml  { render :xml => @nonce, :status => :created, :location => @nonce }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nonce.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nonces/1
  # PUT /nonces/1.xml
  def update
    @nonce = Nonce.find(params[:id])

    respond_to do |format|
      if @nonce.update_attributes(params[:nonce])
        flash[:notice] = 'Nonce was successfully updated.'
        format.html { redirect_to(@nonce) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nonce.errors, :status => :unprocessable_entity }
      end
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
