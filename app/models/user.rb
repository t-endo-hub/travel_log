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

  enum sex: { '男性': 0, '女性': 1, 'その他': 2 }
  enum is_valid: { '有効': true, '退会済': false }

end
