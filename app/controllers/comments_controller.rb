class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @review = @comment.review
    if @comment.save
      redirect_to tourist_spot_review_path(@review.tourist_spot, @review)
    else
      @comments = @review.comments.all
      render '/reviews/show'
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:review_id, :title, :body)
    end
end
