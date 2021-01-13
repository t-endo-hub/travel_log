class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|

      t.integer :user_id
      t.string :image_id
      t.boolean :is_valid, default: true
      t.integer :limit

      t.timestamps
    end
  end
end
