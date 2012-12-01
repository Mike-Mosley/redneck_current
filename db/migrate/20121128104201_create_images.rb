class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :image_type_id
      t.string :name
      t.integer :album_id
      t.integer :user_id
      t.timestamps
    end
    add_index :images, :user_id
    add_index :images, :album_id
  end
end
