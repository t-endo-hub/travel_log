class TouristSpotsController < ApplicationController
  before_action :set_tourist_spot, except: [:new, :create]

  def new
    @tourist_spot = TouristSpot.new
  end

  def create
    tourist_spot = TouristSpot.new(tourist_spot_params)
    tourist_spot.user_id = current_user.id
    if tourist_spot.save
      flash[:notice] = "観光地を登録しました"
      redirect_to root_path
    else
      flash[:alert] = "観光地の登録に失敗しました"
      render 'new'
    end
  end

  def show
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
      :parking,)
  end
end
