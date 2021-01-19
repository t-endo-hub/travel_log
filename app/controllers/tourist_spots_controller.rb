class TouristSpotsController < ApplicationController
  before_action :set_tourist_spot, only: [:show, :update, :edit, :destroy]
  before_action :set_genre_scene, only: [:new, :edit, :create]

  def new
    @tourist_spot = TouristSpot.new
  end

  def create
    @tourist_spot = TouristSpot.new(tourist_spot_params)
    @tourist_spot.user_id = current_user.id
    if @tourist_spot.save
      # 中間テーブルも同時に作成
      TouristSpotGenre.create(tourist_spot_id: @tourist_spot.id, genre_id: Genre.find_by(name: params[:genre]).id)
      TouristSpotScene.create(tourist_spot_id: @tourist_spot.id, scene_id: Scene.find_by(name: params[:scene]).id)
      flash[:notice] = "観光地を登録しました"
      redirect_to tourist_spot_path(tourist_spot)
    else
      render 'new'
    end
  end

  def show
    impressionist(@tourist_spot, nil, unique: [:impressionable_id, :ip_address])
    gon.open_weather_api = ENV['OPEN_WEATHER_MAP_API']
    gon.prefecture_name = @tourist_spot.prefecture_name
  end

  def edit
  end

  def update
    if @tourist_spot.update(tourist_spot_params)
      flash[:notice] = '観光地を編集しました'
      redirect_to root_path
    else
      flash[:alert] = '観光地の編集に失敗しました'
      render root_path
    end
  end

  def destroy
    if @tourist_spot.destroy
      flash[:notice] = '観光地を削除しました'
      redirect_to root_path
    else
      flash[:alert] = '観光地の削除に失敗しました'
      render root_path
    end
  end

  # キーワード検索
  def keyword_search
    @keyword = params[:keyword_search]
    @tourist_spots = TouristSpot.keyword_search(params[:keyword_search])
  end
  

  # ジャンル検索
  def genre_search
    @tourist_spots = TouristSpot.genre_search(params[:genre_search])
    @genre = Genre.find(params[:genre_search])
  end
  
  # 利用シーン検索
  def scene_search
    @tourist_spots = TouristSpot.scene_search(params[:scene_search])
    @scene = Scene.find(params[:scene_search])
  end

  # 都道府県検索
  def prefecture_search
    @tourist_spots = TouristSpot.prefecture_search(params[:prefecture_search])
    @prefecture = JpPrefecture::Prefecture.find(code: params[:prefecture_search])
  end

  # タグ検索
  def tag_search
    @tourist_spots = TouristSpot.tagged_with(params[:tag_name])
    @tags = TouristSpot.tag_counts.order(taggings_count: 'DESC').limit(20)
  end

  # 地図
  def map
    @tourist_spot = TouristSpot.find(params[:tourist_spot_id])
    gon.latitude = @tourist_spot.latitude
    gon.longitude = @tourist_spot.longitude
    gon.open_weather_api = ENV['OPEN_WEATHER_MAP_API']
    gon.prefecture_name = @tourist_spot.prefecture_name
  end
  

  
  private

  def set_tourist_spot
    @tourist_spot = TouristSpot.find(params[:id])
  end

  def set_genre_scene
    @genres = Genre.all
    @scenes = Scene.all
    @genre_names = []
    @scene_names = []
    @genres.each do |genre|
      @genre_names.push(genre.name)
    end
    @scenes.each do |scene|
      @scene_names.push(scene.name)
    end
  end

  def tourist_spot_params
    params.require(:tourist_spot).permit(
      :spot_image,
      :name,
      :postcode,
      :prefecture_code,
      :address_city,
      :address_street,
      :address_building,
      :latitude,
      :longitude,
      :introduction,
      :access,
      :phone_number,
      :business_hour,
      :parking,
      :home_page,
      :tag_list
    )
  end
end
