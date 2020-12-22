class AddImpressionsCountToTouristSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :tourist_spots, :impressions_count, :integer, default: 0
  end
end
