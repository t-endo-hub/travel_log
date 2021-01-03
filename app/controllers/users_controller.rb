class UsersController < ApplicationController
  before_action :set_user
  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'ユーザー情報を編集しました'
      redirect_to user_path(@user)
    else
      flash[:alert] = 'ユーザー情報の編集に失敗しました'
      render 'edit'
    end
  end
  

  private
  
  def user_params
    params.require(:user).permit(
      :name, 
      :age, 
      :email, 
      :sex, 
      :prefecture_code,
      :postcode, 
      :address_city, 
      :address_street, 
      :address_building, 
      :introduction,
      :profile_image,
      :point,
      :rank
    )
  end

  def set_user
    @user = User.find(params[:id])
  end
end
