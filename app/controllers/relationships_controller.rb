class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # フォローする
  def follow
    @user = User.find(params[:id])
    unless current_user.following?(@user)
      current_user.follow(params[:id])
      @user.create_notification_follow!(current_user)
    end
  end

  # アンフォローする
  def unfollow
    @user = User.find(params[:id])
    if current_user.following?(@user)
      current_user.unfollow(params[:id])
    end
  end

end
