class TouristSpotsController < ApplicationController
  def new
    @tourist_spot = TouristSpot.new
  end
end
