class TouristSpotGenre < ApplicationRecord
  belongs_to :tourist_spot
  belongs_to :genre
end
