class TouristSpot < ApplicationRecord
  attachment :spot_image

  belongs_to :user
  has_many :favorites
  has_many :wents
  has_many :reviews
  has_many :tourist_spot_genres, dependent: :destroy
  has_many :genres, through: :tourist_spot_genres
  has_many :tourist_spot_scenes, dependent: :destroy
  has_many :scenes, through: :tourist_spot_scenes




   # 「行きたい！」に追加しているかを確認
   def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 「行った！」に追加しているかを確認
  def wented_by?(user)
    wents.where(user_id: user.id).exists?
  end

    # ジャンル検索
    def self.genre_search(genre_search)
      TouristSpot.joins(:tourist_spot_genres).where("tourist_spot_genres.genre_id = #{genre_search}")
    end
    
    # シーン検索
    def self.scene_search(scene_search)
      TouristSpot.joins(:tourist_spot_scenes).where("tourist_spot_scenes.scene_id = #{scene_search}")
    end
end
