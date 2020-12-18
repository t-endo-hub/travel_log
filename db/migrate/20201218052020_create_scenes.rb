class CreateScenes < ActiveRecord::Migration[5.2]
  def change
    create_table :scenes do |t|
      t.string :name
      t.string :scene_image_id
      t.timestamps
    end
  end
end
