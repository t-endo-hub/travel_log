class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tourist_spot

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

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
    case user.point
    when 0
      user.rank = 'レギュラー'
    when 1
      user.rank = 'シルバー'
      Coupon.coupon_create(user)
    when 2
      user.rank = 'ゴールド'
      Coupon.coupon_create(user)
    when 3
      user.rank = 'プラチナ'
      Coupon.coupon_create(user)
    when 4
      user.rank = 'ダイヤモンド'
      Coupon.coupon_create(user)
    end
    user.save(validate: false)
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

  # いいね通知
  def create_notification_like!(current_user)
    # すでにいいねされているかを確認
    temp = Notification.where([
      'visitor_id = ? and visited_id = ? and review_id = ? and action = ? ',
      current_user.id, user_id, id, 'like'
    ])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        review_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # コメント通知
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(review_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  # コメント通知
  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      review_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
