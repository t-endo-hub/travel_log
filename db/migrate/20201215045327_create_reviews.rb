class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :tourist_spot, foreign_key: true
      t.string :review_image_id
      t.string :title, null: false
      t.text :body, null: false
      t.integer :score, null: false
      t.boolean :is_value, default: true, null: false
      t.timestamps
    end
  end
end
