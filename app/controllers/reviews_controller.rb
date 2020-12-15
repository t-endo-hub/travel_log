class ReviewsController < ApplicationController

  def index
    @tourist_spot_reviews = Review.where(tourist_spot_id: params[:tourist_spot_id])
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

  private
  def review_params
    params.require(:review).permit(:review_image, :title, :body, :score)
  end
end
