class HomesController < ApplicationController
  def top
    @user = current_user
    @tourist_spots = TouristSpot.all
    @genres = Genre.all
    @scenes = Scene.all
    @tourist_spots_fav = TouristSpot.fav_ranking # 観光スポット「行きたい!」ランキング
    @tourist_spots_pv = TouristSpot.pv_ranking # 観光スポットPVランキング
    @tags = TouristSpot.tag_ranking # タグランキング
  end
end
