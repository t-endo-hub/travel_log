class ReviewsController < ApplicationController
  before_action :set_review, except: [:index, :new, :create]

  def index
    @tourist_spot_reviews = Review.where(tourist_spot_id: params[:tourist_spot_id])
    @tourist_spot = TouristSpot.find(params[:tourist_spot_id])
  end

  def new
    @review = Review.new
  end

  def create
    @tourist_spot = TouristSpot.find(params[:tourist_spot_id])
    review = @tourist_spot.reviews.new(review_params)
    review.user_id = current_user.id
    if review.save
      flash[:notice] = 'レビューを追加しました'
      redirect_to tourist_spot_path(@tourist_spot)
    else
      flash[:alert] = 'レビューの追加に失敗しました'
      render 'new'
    end
  end

  def show
   
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:notice] = "レビューを編集しました"
      redirect_to tourist_spot_reviews_path(@review.tourist_spot)
    else
      flash[:alert] = "レビューの編集に失敗しました"
      render 'edit'
    end
  end

  def destroy
    if @review.destroy
      flash[:notice] = "レビューを削除しました"
      redirect_to tourist_spot_reviews_path(@review.tourist_spot)
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
