class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tourist_spot

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  attachment :review_image

  # すでにいいねしているかを確認
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  def self.ranking
    self.find(Like.group(:review_id).order('count(review_id) DESC').limit(10).pluck(:review_id))
  end
end
