class WentsController < ApplicationController
  before_action :set_tourist_spot
  before_action :authenticate_user!

  def create
    unless @tourist_spot.wented_by?(current_user)
      went = current_user.wents.new(tourist_spot_id: @tourist_spot.id)
      went.save
    end
  end

  def destroy
    if @tourist_spot.wented_by?(current_user)
      went = current_user.wents.find_by(tourist_spot_id: @tourist_spot.id)
      went.destroy
    end
  end

  private

  def set_tourist_spot
    @tourist_spot = TouristSpot.find(params[:tourist_spot_id])
  end
end
