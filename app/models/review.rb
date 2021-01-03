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

  # ランキング
  def self.ranking
    self.find(Like.group(:review_id).order('count(review_id) DESC').limit(10).pluck(:review_id))
  end

  #ユーザーのポイントによってランク付け
  def user_rank_update(user)
    if user.point < 10
      user.rank = 'レギュラー'
    elsif user.point < 50
      user.rank = 'シルバー'
    elsif user.point < 100
      user.rank = 'ゴールド'
    elsif user.point < 300
      user.rank = 'プラチナ'
    elsif user.point >= 300
      user.rank = 'ダイヤモンド'
    end
    user.save!
  end
  
end
