class TouristSpotsController < ApplicationController
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
    @tourist_spot = TouristSpot.find(params[:id])
  end

  private
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
