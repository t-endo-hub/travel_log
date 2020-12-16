class CreateWents < ActiveRecord::Migration[5.2]
  def change
    create_table :wents do |t|
      t.references :user, foreign_key: true
      t.references :tourist_spot, foreign_key: true
      t.timestamps
    end
  end
end
