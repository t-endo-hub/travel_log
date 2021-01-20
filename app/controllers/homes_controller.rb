class HomesController < ApplicationController
  def top
    @user = current_user
    @genres = Genre.where(ancestry: nil)
    @scenes = Scene.all
    @tourist_spots_fav = TouristSpot.fav_ranking # 観光スポット「行きたい!」ランキング
    @tourist_spots_pv = TouristSpot.pv_ranking # 観光スポットPVランキング
    @tags = TouristSpot.tag_ranking # タグランキング
    @reviews = Review.ranking # レビューランキング
    @users = User.ranking
    gon.tourist_spots = TouristSpot.all
  end

  def new
    @children = Genre.find(params[:parent_id]).children
  end
end
