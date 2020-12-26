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

  enum sex: { '男性': 0, '女性': 1, 'その他': 2 }
  enum is_valid: { '有効': true, '退会済': false }

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


end
