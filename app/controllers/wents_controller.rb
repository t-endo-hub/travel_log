class WentsController < ApplicationController
  before_action :set_tourist_spot
  
  def create
    unless @tourist_spot.wented_by?(current_user)
      current_user.wents.create(tourist_spot_id: @tourist_spot.id)
      redirect_to tourist_spot_path(@tourist_spot)
    end
  end

  def destroy
    if @tourist_spot.wented_by?(current_user)
      current_user.wents.find_by(tourist_spot_id: @tourist_spot.id).destroy
      redirect_to tourist_spot_path(@tourist_spot)
    end
  end

  private
  def set_tourist_spot
    @tourist_spot = TouristSpot.find(params[:tourist_spot_id])
  end
end
