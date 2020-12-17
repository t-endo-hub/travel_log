class HomesController < ApplicationController
  def top
    @user = current_user
    @tourist_spots = TouristSpot.all
    @genres = Genre.all
  end
end
