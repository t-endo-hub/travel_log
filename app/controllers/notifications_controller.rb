class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  # 通知を全削除
  def destroy
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to user_notifications_path
  end

end
