class Scene < ApplicationRecord
  has_many :tourist_spot_scenes
  has_many :tourist_spots, through: :tourist_spot_scenes
  attachment :scene_image
end
