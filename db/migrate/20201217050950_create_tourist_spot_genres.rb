class CreateTouristSpotGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :tourist_spot_genres do |t|
      t.references :tourist_spot, foreign_key: true
      t.references :genre, foreign_key: true
      t.timestamps
    end
  end
end
