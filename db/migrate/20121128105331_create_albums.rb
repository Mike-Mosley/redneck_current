class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :user_id
      t.string :name
      t.timestamps
    end
    add_index :albums, :user_id
  end
end
