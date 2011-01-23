class RelationshipsController < ApplicationController
  before_filter :authenticate

  respond_to :html, :js

  def create
    @user = User.find_by_id(params[:relationship][:followed_id])
    current_user.follow!(@user)
    UserMailer.follower_notification(@user, current_user).deliver
    respond_with @user
  end

  def destroy
    @user = Relationship.find_by_id(params[:id]).followed
    current_user.unfollow!(@user)
    respond_with @user
  end
end