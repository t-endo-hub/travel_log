class TouristSpotsController < ApplicationController
  before_action :set_tourist_spot, only: [:show, :update, :edit, :destroy]

  def new
    @tourist_spot = TouristSpot.new
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

  def create
    tourist_spot = TouristSpot.new(tourist_spot_params)
    tourist_spot.user_id = current_user.id
    if tourist_spot.save
      # 中間テーブルも同時に作成
      TouristSpotGenre.create(tourist_spot_id: tourist_spot.id, genre_id: Genre.find_by(name: params[:genre]).id)
      TouristSpotScene.create(tourist_spot_id: tourist_spot.id, scene_id: Scene.find_by(name: params[:scene]).id)
      flash[:notice] = "観光地を登録しました"
      redirect_to root_path
    else
      flash[:alert] = "観光地の登録に失敗しました"
      render 'new'
    end
  end

  def show
    impressionist(@tourist_spot, nil, unique: [:impressionable_id, :ip_address])
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
  
  private

  def set_tourist_spot
    @tourist_spot = TouristSpot.find(params[:id])
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
      :introduction,
      :access,
      :phone_number,
      :business_hour,
      :parking,
      :tag_list)
  end
end
