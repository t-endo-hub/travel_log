class CreateTouristSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :tourist_spots do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.string :spot_image_id, null: false
      t.string :postcode, null: false
      t.integer :prefecture_code, null: false
      t.string :address_city, null: false
      t.string :address_street, null: false
      t.string :address_building
      t.text :introduction, null: false
      t.text :access, null: false
      t.string :phone_number, null: false
      t.string :business_hour, null: false
      t.boolean :is_parking, default: true, null: false
      t.timestamps
    end
  end
end
