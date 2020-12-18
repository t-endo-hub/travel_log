class ScenesController < ApplicationController
  before_action :set_scene, only: [:edit, :update, :destroy]

  def index
    @scene = Scene.new
    @scenes = Scene.all
  end

  def edit
  end

  def update
    if @scene.update(scene_params)
      flash[:notice] = 'シーンを更新しました'
      redirect_to scenes_path
    else
      flash[:alert] = 'シーンの更新に失敗しました'
      render 'edit'
    end
  end

  def create
    @scene = Scene.new(scene_params)
    if @scene.save
      flash[:notice] = 'シーンを登録しました'
    else
      flash[:alert] = 'シーンの登録に失敗しました'
    end
      redirect_to scenes_path
  end

  def destroy
    if @scene.destroy
      flash[:notice] = 'シーンを削除しました'
    else
      flash[:alert] = 'シーンの削除に失敗しました'
    end
    redirect_to scenes_path
  end

  private
  def set_scene
    @scene = Scene.find(params[:id])
  end

  def scene_params
    params.require(:scene).permit(:scene_image, :name)
  end
end
