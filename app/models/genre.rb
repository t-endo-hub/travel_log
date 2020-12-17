class Genre < ApplicationRecord
  attachment :genre_image
  has_many :tourist_spot_genres
  has_many :tourist_spots, through: :tourist_spot_genres
end
