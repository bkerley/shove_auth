class AclpartsController < ApplicationController
  # GET /aclparts
  # GET /aclparts.xml
  def index
    @aclparts = Aclpart.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aclparts }
    end
  end

  # GET /aclparts/1
  # GET /aclparts/1.xml
  def show
    @aclpart = Aclpart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aclpart }
    end
  end

  # GET /aclparts/new
  # GET /aclparts/new.xml
  def new
    @aclpart = Aclpart.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aclpart }
    end
  end

  # GET /aclparts/1/edit
  def edit
    @aclpart = Aclpart.find(params[:id])
  end

  # POST /aclparts
  # POST /aclparts.xml
  def create
    @aclpart = Aclpart.new(params[:aclpart])

    respond_to do |format|
      if @aclpart.save
        flash[:notice] = 'Aclpart was successfully created.'
        format.html { redirect_to(@aclpart) }
        format.xml  { render :xml => @aclpart, :status => :created, :location => @aclpart }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aclpart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aclparts/1
  # PUT /aclparts/1.xml
  def update
    @aclpart = Aclpart.find(params[:id])

    respond_to do |format|
      if @aclpart.update_attributes(params[:aclpart])
        flash[:notice] = 'Aclpart was successfully updated.'
        format.html { redirect_to(@aclpart) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aclpart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aclparts/1
  # DELETE /aclparts/1.xml
  def destroy
    @aclpart = Aclpart.find(params[:id])
    @aclpart.destroy

    respond_to do |format|
      format.html { redirect_to(aclparts_url) }
      format.xml  { head :ok }
    end
  end
end
