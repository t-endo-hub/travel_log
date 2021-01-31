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

  def new_guest
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = '000000000'
      user.name = 'testUser'
      user.age = 20
      user.sex = 1
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end