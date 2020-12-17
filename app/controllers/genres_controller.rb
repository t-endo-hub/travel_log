class GenresController < ApplicationController
  before_action :set_genre, only: [:edit, :update, :destroy]

  def index
    @genre = Genre.new
    @genres = Genre.all
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      flash[:notice] = 'ジャンルを更新しました'
      redirect_to genres_path
    else
      flash[:alert] = 'ジャンルの更新に失敗しました'
      render 'edit'
    end
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      flash[:notice] = 'ジャンルを登録しました'
    else
      flash[:alert] = 'ジャンルの登録に失敗しました'
    end
      redirect_to genres_path
  end

  def destroy
    if @genre.destroy
      flash[:notice] = 'ジャンルを削除しました'
    else
      flash[:alert] = 'ジャンルの削除に失敗しました'
    end
    redirect_to genres_path
  end

  private
  def set_genre
    @genre = Genre.find(params[:id])
  end

  def genre_params
    params.require(:genre).permit(:genre_image, :name)
  end
end
