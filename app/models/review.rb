class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tourist_spot

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  attachment :review_image

  validates :review_image, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 200 }
  validates :score, presence: true


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
      Coupon.coupon_create(user)
    elsif user.point < 100
      user.rank = 'ゴールド'
      Coupon.coupon_create(user)
    elsif user.point < 300
      user.rank = 'プラチナ'   
      Coupon.coupon_create(user)
    elsif user.point >= 300
      user.rank = 'ダイヤモンド'
      Coupon.coupon_create(user)
    end
    user.save!
  end
  
end
