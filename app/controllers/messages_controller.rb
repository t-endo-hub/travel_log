class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    message.save ? (redirect_to user_room_path(message.room)) : (redirect_back(fallback_location: root_path))
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def message_params
      params.require(:message).permit(:room_id, :body)
    end

end
