class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  has_many :tourist_spots
  has_many :favorites
  has_many :wents
  has_many :reviews
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy


  enum sex: { '男性': 0, '女性': 1, 'その他': 2 }
  enum is_valid: { '有効': true, '退会済': false }

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
  
  
end
