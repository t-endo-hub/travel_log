class RemoveIsParkingFromTouristSpot < ActiveRecord::Migration[5.2]
  def change
    remove_column :tourist_spots, :is_parking, :boolean
  end
end
