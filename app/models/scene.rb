class Scene < ApplicationRecord
  attachment :scene_image
  has_many :tourist_spot_scenes
  has_many :tourist_spots, through: :tourist_spot_scenes

  validates :name, presence: true, length: { maximum: 20 }

end
