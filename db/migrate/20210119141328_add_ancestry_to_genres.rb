class AddAncestryToGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :ancestry, :string
    add_index :genres, :ancestry
  end
end
