class CreateWents < ActiveRecord::Migration[5.2]
  def change
    create_table :wents do |t|
      t.references :user
      t.references :tourist_spot
      t.timestamps
    end
  end
end
