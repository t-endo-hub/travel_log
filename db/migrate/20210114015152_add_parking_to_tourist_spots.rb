class AddParkingToTouristSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :tourist_spots, :parking, :text, null: false
    add_column :tourist_spots, :home_page, :string, null: false
  end
end
