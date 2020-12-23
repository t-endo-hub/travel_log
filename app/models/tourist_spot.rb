class TouristSpot < ApplicationRecord
  attachment :spot_image
  is_impressionable counter_cache: true # PV数取得
  acts_as_taggable # タグ付け



  belongs_to :user
  has_many :favorites
  has_many :wents
  has_many :reviews
  has_many :tourist_spot_genres, dependent: :destroy
  has_many :genres, through: :tourist_spot_genres
  has_many :tourist_spot_scenes, dependent: :destroy
  has_many :scenes, through: :tourist_spot_scenes


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

  # 都道府県検索
  def self.prefecture_search(prefecture_search)
    TouristSpot.where(prefecture_code: prefecture_search)
  end

  # 「行きたい！」ランキング
  def self.fav_ranking
    self.find(Favorite.group(:tourist_spot_id).order('count(tourist_spot_id) DESC').limit(10).pluck(:tourist_spot_id))
  end

  # PVランキング
  def self.pv_ranking
    self.order(impressions_count: 'DESC').limit(10)
  end
  
  # タグランキング
  def self.tag_ranking
    self.all.tag_counts.order(taggings_count: 'DESC').limit(10)
  end

  # 緯度経度を取得
  geocoded_by :geocode_full_address
  after_validation :geocode

  # geocoder用の住所
  def geocode_full_address
    self.address_city + self.address_street
  end
  
  
  
end
