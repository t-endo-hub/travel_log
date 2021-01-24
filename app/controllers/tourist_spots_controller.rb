class TouristSpotsController < ApplicationController
  before_action :set_tourist_spot, only: [:show, :update, :edit, :destroy]
  before_action :set_genre_scene, only: [:new, :edit, :create]

  def new
    @tourist_spot = TouristSpot.new
    @genre_parent_array = Genre.genre_parent_array_create # 親ジャンルのみを抽出し配列化
  end

  # 親ジャンルが選択された後に動くアクション
  def get_genre_children
    @genre_children = Genre.find(params[:parent_id]).children # 選択された親ジャンルに紐付く子ジャンルの配列を取得
  end

  # 子ジャンルが選択された後に動くアクション
  def get_genre_grandchildren
    @genre_grandchildren = Genre.find(params[:child_id]).children # 選択された子ジャンルに紐付く孫ジャンルの配列を取得
  end

  def create
    @tourist_spot = TouristSpot.new(tourist_spot_params)
    @tourist_spot.user_id = current_user.id
    if @tourist_spot.save
      # ジャンル(中間テーブルのレコード)を作成
      TouristSpotGenre.maltilevel_genre_create(
        @tourist_spot,
        params[:parent_id],
        params[:children_id],
        params[:grandchildren_id]
      )
      redirect_to tourist_spot_path(@tourist_spot)
    else
      @genre_parent_array = Genre.genre_parent_array_create
			render 'new'
    end
  end

  def show
    impressionist(@tourist_spot, nil, unique: [:impressionable_id, :ip_address])
    gon.open_weather_api = ENV['OPEN_WEATHER_MAP_API']
    gon.prefecture_name = @tourist_spot.prefecture_name
  end

  def edit
    unless @tourist_spot.user == current_user
      redirect_to root_path
    end
    @genre_parent_array = Genre.genre_parent_array_create
  end

  def update
    if @tourist_spot.update(tourist_spot_params)
      tourist_spot_genres = TouristSpotGenre.where(tourist_spot_id: @tourist_spot.id)
      tourist_spot_genres.destroy_all # ジャンル(中間テーブルのレコード)を一旦全削除
      TouristSpotGenre.maltilevel_genre_create(
        @tourist_spot,
        params[:parent_id],
        params[:children_id],
        params[:grandchildren_id]
      )
      redirect_to tourist_spot_path(@tourist_spot)
    else
      @genre_parent_array = Genre.genre_parent_array_create
			render 'edit'
		end
  end

  def destroy
    @tourist_spot.destroy
		redirect_to root_path
  end

  # キーワード検索
  def keyword_search
    tourist_spots = TouristSpot.keyword_search(params[:keyword_search])
    @keyword_search = params[:keyword_search]
    kaminari = TouristSpot.sort(params[:sort], tourist_spots) # kaminariの仕様上、Arrayから直接ページネーションをする事が出来ないので一旦変数に代入
    @tourist_spots = Kaminari.paginate_array(kaminari).page(params[:page]).per(20)
  end
  

  # ジャンル検索
  def genre_search
    tourist_spots = TouristSpot.genre_search(params[:genre_search])
    @genre_search = params[:genre_search]
    @genre = Genre.find_by(id: @genre_search)
    kaminari = TouristSpot.sort(params[:sort], tourist_spots)
    @tourist_spots = Kaminari.paginate_array(kaminari).page(params[:page]).per(20)
  end
  
  # 利用シーン検索
  def scene_search
    tourist_spots = TouristSpot.scene_search(params[:scene_search])
    @scene_search = params[:scene_search]
    @scene = Scene.find_by(id: @scene_search)
    kaminari = TouristSpot.sort(params[:sort], tourist_spots)
    @tourist_spots = Kaminari.paginate_array(kaminari).page(params[:page]).per(20)
  end

  # 都道府県検索
  def prefecture_search
    tourist_spots = TouristSpot.prefecture_search(params[:prefecture_search])
    @prefecture_search = params[:prefecture_search]
    @prefecture = JpPrefecture::Prefecture.find(code: @prefecture_search)
    kaminari = TouristSpot.sort(params[:sort], tourist_spots)
    @tourist_spots = Kaminari.paginate_array(kaminari).page(params[:page]).per(20)
  end

  # タグ検索
  def tag_search
    @tourist_spots = TouristSpot.tagged_with(params[:tag_name]).page(params[:page]).per(20)
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

  # 行きたい！一覧
  def favorites
    @tourist_spots = current_user.favorite_tourist_spots.rank(:row_order).page(params[:page]).per(20)
  end

  # 行った！一覧
  def wents
    @tourist_spots = current_user.went_tourist_spots.rank(:row_order).page(params[:page]).per(20)
  end
  
  # ドラッグ&ドロップ
  def sort
    tourist_spot = TouristSpot.find(params[:tourist_spot_id])
    tourist_spot.update(tourist_spot_params)
    render body: nil
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
      :tag_list,
      :row_order_position
    )
  end
end
