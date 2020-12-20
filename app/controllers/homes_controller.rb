class HomesController < ApplicationController
  def top
    @user = current_user
    @tourist_spots = TouristSpot.all
    @genres = Genre.all
    @scenes = Scene.all
    @tourist_spots_fav = TouristSpot.fav_ranking # 観光スポット「行きたい!」ランキング
  end
end
