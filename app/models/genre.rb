class Genre < ApplicationRecord
  attachment :genre_image
  has_many :tourist_spot_genres
end
