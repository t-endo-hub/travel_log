class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update] 
  def show
    @user = User.find(params[:id])
    # Entryモデルからログインユーザーのレコードを抽出
    @current_entry = Entry.where(user_id: current_user.id)
    # Entryモデルからメッセージ相手のレコードを抽出
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          # ルームが存在する場合
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      # ルームが存在しない場合は新規作成
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
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

  # キーワード検索
  def keyword_search
    @users = User.keyword_search(params[:search])
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
