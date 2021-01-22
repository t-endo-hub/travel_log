module ApplicationHelper
  def unchecked_notifications(user)
    user.passive_notifications.where(checked: false)
  end
end
