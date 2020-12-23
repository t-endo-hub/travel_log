class AddColumnToTouristSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :tourist_spots, :latitude, :float
    add_column :tourist_spots, :longitude, :float
  end
end
