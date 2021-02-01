class User::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    @tourist_spot = TouristSpot.find(params[:tourist_spot_id])
    kaminari = Review.sort(params[:sort], @tourist_spot.reviews)
    @reviews = Kaminari.paginate_array(kaminari).page(params[:page]).per(20)
  end

  def new
    @review = Review.new
  end

  def create
    @tourist_spot = TouristSpot.find(params[:tourist_spot_id])
    review = @tourist_spot.reviews.new(review_params)
    review.user_id = current_user.id
    if review.save
      review.user.point += 1 # レビューを投稿したユーザーにポイントを与える
      review.user_rank_update(review.user) # レビューを投稿したユーザーのランクをアップデート
      flash[:notice] = 'レビューを追加しました'
      redirect_to tourist_spot_(@tourist_spot)
    else
      flash[:alert] = 'レビューの追加に失敗しました'
      render 'new'
    end
  end

  def show
    @comment = Comment.new
    @comments = @review.comments.order(id: 'DESC').page(params[:page]).per(20)
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:notice] = "レビューを編集しました"
      redirect_to user_tourist_spot_reviews_path(@review.tourist_spot)
    else
      flash[:alert] = "レビューの編集に失敗しました"
      render 'edit'
    end
  end

  def destroy
    if @review.destroy
      flash[:notice] = "レビューを削除しました"
      redirect_to user_tourist_spot_reviews_path(@review.tourist_spot)
    else
      flash[:alert] = "レビューの削除に失敗しました"
      render 'edit'
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:review_image, :title, :body, :score)
  end
end
