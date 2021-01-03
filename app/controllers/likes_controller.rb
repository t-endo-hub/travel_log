class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    unless @review.liked_by?(current_user)
      like = current_user.likes.new(review_id: @review.id)
      like.save
    end
    @review.user.point += 1 # いいねしたレビューを投稿したユーザーにポイントを与える
    @review.user_rank_update(@review.user) # いいねをしたレビューを投稿したユーザーのランクをアップデート
  end

  def destroy
    @review = Review.find(params[:review_id])
    if @review.liked_by?(current_user)
      like = current_user.likes.find_by(review_id: @review.id)
      like.destroy
    end
    @review.user.point -= 1
    @review.user_rank_update(@review.user) # いいねを外したレビューを投稿したユーザーのランクをアップデート
  end

end
