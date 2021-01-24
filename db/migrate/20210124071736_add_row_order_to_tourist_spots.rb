class AddRowOrderToTouristSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :tourist_spots, :row_order, :integer
  end
end
