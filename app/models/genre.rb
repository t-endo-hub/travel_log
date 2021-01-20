class Genre < ApplicationRecord
  has_ancestry
  attachment :genre_image
  has_many :tourist_spot_genres
  has_many :tourist_spots, through: :tourist_spot_genres

  validates :name, presence: true, length: { maximum: 20 }

  def self.genre_parent_array_create
    genre_parent_array = ['---']
    Genre.where(ancestry: nil).each do |parent|
      genre_parent_array << [parent.name, parent.id]
    end
    return genre_parent_array
  end


end
