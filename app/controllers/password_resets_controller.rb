class PasswordResetsController < ApplicationController
  # GET /password_resets
  # GET /password_resets.xml
  def index
    @password_resets = PasswordReset.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @password_resets }
    end
  end

  # GET /password_resets/1
  # GET /password_resets/1.xml
  def show
    @password_reset = PasswordReset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @password_reset }
    end
  end

  # GET /password_resets/new
  # GET /password_resets/new.xml
  def new
    @password_reset = PasswordReset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @password_reset }
    end
  end

  # GET /password_resets/1/edit
  def edit
    @password_reset = PasswordReset.find(params[:id])
  end

  # POST /password_resets
  # POST /password_resets.xml
  def create
    @password_reset = PasswordReset.new(params[:password_reset])

    respond_to do |format|
      if @password_reset.save
        format.html { redirect_to(@password_reset, :notice => 'Password reset was successfully created.') }
        format.xml  { render :xml => @password_reset, :status => :created, :location => @password_reset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @password_reset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /password_resets/1
  # PUT /password_resets/1.xml
  def update
    @password_reset = PasswordReset.find(params[:id])

    respond_to do |format|
      if @password_reset.update_attributes(params[:password_reset])
        format.html { redirect_to(@password_reset, :notice => 'Password reset was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @password_reset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /password_resets/1
  # DELETE /password_resets/1.xml
  def destroy
    @password_reset = PasswordReset.find(params[:id])
    @password_reset.destroy

    respond_to do |format|
      format.html { redirect_to(password_resets_url) }
      format.xml  { head :ok }
    end
  end
end
