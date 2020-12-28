class FavoritesController < ApplicationController
  before_action :set_tourist_spot
  before_action :authenticate_user!

  def create
    unless @tourist_spot.favorited_by?(current_user)
      favorite = current_user.favorites.new(tourist_spot_id: @tourist_spot.id)
      favorite.save
    end
  end

  def destroy
    if @tourist_spot.favorited_by?(current_user)
      favorite = current_user.favorites.find_by(tourist_spot_id: @tourist_spot.id)
      favorite.destroy
    end
  end

  private
  def set_tourist_spot
    @tourist_spot = TouristSpot.find(params[:tourist_spot_id])
  end
end
