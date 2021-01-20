class TouristSpotGenre < ApplicationRecord
  belongs_to :tourist_spot
  belongs_to :genre

  # 多階層ジャンルの作成
  def self.maltilevel_genre_create(tourist_spot, parent_id, children_id, grandchildren_id)
    if parent_id.present? && parent_id != '---'
      genre = Genre.find(parent_id)
      tourist_spot_genre_create(tourist_spot, genre)
    end

    if children_id.present? && children_id != '---'
      genre = Genre.find(children_id)
      tourist_spot_genre_create(tourist_spot, genre)
    end

    if grandchildren_id.present? && grandchildren_id != '---'
      genre = Genre.find(grandchildren_id)
      tourist_spot_genre_create(tourist_spot, genre)
    end
  end

  private

    def self.tourist_spot_genre_create(tourist_spot, genre)
      tourist_spot_genre = TouristSpotGenre.new
      tourist_spot_genre.tourist_spot_id = tourist_spot.id
      tourist_spot_genre.genre_id = genre.id
      tourist_spot_genre.save
    end

end
