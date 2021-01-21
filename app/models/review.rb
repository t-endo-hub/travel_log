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
  
  def self.sort(sort, reviews)
    if reviews.present?
      case sort
      when '1'
        # おすすめ順
        Review.find(
          Like.where(review_id: reviews.pluck(:id))
            .group(:review_id)
            .order('count(review_id) DESC')
            .pluck(:review_id)
        )
      when '2'
        # 新着順
        reviews.order(id: 'DESC')
      when '3'
        # コメント数順
        # おすすめ順
        Review.find(
          Comment.where(review_id: reviews.pluck(:id))
            .group(:review_id)
            .order('count(review_id) DESC')
            .pluck(:review_id)
        )
      when '4'
        # 点数順
        reviews.order(score: 'DESC')
      when '5'
        # 男性のみ
        reviews.includes(:user).where(users: { sex:'男性' })
      when '6'
        # 女性のみ
        reviews.includes(:user).where(users: { sex:'女性' })
      else
        reviews
      end
    else
      # kaminariのエラー対策で空の配列を代入
      reviews = []
    end
  end

end
