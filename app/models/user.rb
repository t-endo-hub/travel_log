class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  has_many :tourist_spots
  has_many :favorites, dependent: :destroy
  has_many :favorite_tourist_spots, through: :favorites, source: :tourist_spot
  has_many :wents, dependent: :destroy
  has_many :went_tourist_spots, through: :wents, source: :tourist_spot
  has_many :reviews
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :follower, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followed, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  has_many :coupons, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  enum sex: { '男性': 0, '女性': 1, 'その他': 2 }
  enum is_valid: { '有効': true, '退会済': false }
  enum rank: { 'レギュラー': 0, 'シルバー': 1, 'ゴールド': 2, 'プラチナ': 3, 'ダイヤモンド': 4 }


  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :sex, presence: true
  validates :age, presence: true
  validates :postcode, allow_blank: true, format: { with: /\A[0-9]{3}-[0-9]{4}\z/ }
  validates :address_city, length: { maximum: 50 }
  validates :address_street, length: { maximum: 50 }
  validates :address_building, length: { maximum: 50 }
  validates :introduction, length: { maximum: 200 }


  # 住所自動入力
  include JpPrefecture
  jp_prefecture :prefecture_code

  # 都道府県名
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  # 都道府県名
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーをアンフォローする
  def unfollow(user_id)
      follower.find_by(followed_id: user_id).destroy
  end

  # フォローしているかを確認
  def following?(user)
      following_user.include?(user)
  end

  # 次のランクまでのポイント数を計算
  def next_rank(user)
    case user.rank
    when 'レギュラー'
      10 - user.point
    when 'シルバー'
      50 - user.point
    when 'ゴールド'
      100 - user.point
    when 'プラチナ'
      300 - user.point
    end
  end

  # ランキング
  def self.ranking
    self.all.order(point: 'DESC').limit(10)
  end
  
  #キーワード検索
  def self.keyword_search(search)
    if search.present?
      User.where(['name LIKE ? OR introduction LIKE ?', "%#{ search }%", "%#{ search }%"])
    end
  end
  
  # ログインユーザーの順位を計算
  def my_rank(current_user)
    users = User.ranking
    @my_rank = 0
    users.each do |user|
      @my_rank += 1
      if user.id == current_user.id
        break
      end
    end
    return @my_rank
  end

  # フォロー通知
  def create_notification_follow!(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ? ',current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # DM通知
  def create_notification_message!(current_user, message_id, visited_id)
    # binding.pry
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      message_id: message_id,
      visited_id: visited_id,
      action: 'message'
    )
    notification.save if notification.valid?
  end
  
end
