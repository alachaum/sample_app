class PasswordResetsController < ApplicationController
  before_filter :unsigned_user, :only => [:new, :create, :show, :edit, :update]
  
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
    @title = "Password Reset"
  end

  # GET /password_resets/new
  # GET /password_resets/new.xml
  def new
    @password_reset = PasswordReset.new
    @title = "Password Reset"
  end

  # GET /password_resets/1/edit
  def edit
    @password_reset = PasswordReset.find(params[:id])
    
    if @password_reset && @password_reset.active && @password_reset.token == params[:token]
      @title = "Password Reset"
    else
      redirect_to root_path
    end
  end

  # POST /password_resets
  # POST /password_resets.xml
  def create
    @password_reset = PasswordReset.new(params[:password_reset])    

    if @password_reset.save
      flash[:success] = "Your request has been processed successfully"
      user = User.find(@password_reset.user_id)
      UserMailer.password_reset_confirmation(@password_reset).deliver
      redirect_to @password_reset
    else
      @title = "Password Reset"
      render 'new'
    end
  end

  # PUT /password_resets/1
  # PUT /password_resets/1.xml
  def update
    @password_reset = PasswordReset.find(params[:id])
    token = params[:password_reset][:token]
    
    if @password_reset.active && token == @password_reset.token
      if @password_reset.user.update_attributes(params[:user])
        sign_in(@password_reset.user)
        flash[:success] = "Your password has been reset successfully"
        @password_reset.active = false
        @password_reset.save
        redirect_to root_path
      else
        render 'edit'
      end
    else
      redirect_to root_path
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
  
  private
    def unsigned_user
      redirect_to root_path if signed_in?
    end
end
