class TouristSpot < ApplicationRecord
  attachment :spot_image

  belongs_to :user
  has_many :favorites
  has_many :wents
  has_many :reviews
  has_many :tourist_spot_genres

   # 「行きたい！」に追加しているかを確認
   def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 「行った！」に追加しているかを確認
  def wented_by?(user)
    wents.where(user_id: user.id).exists?
  end
end
