class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :addressable_id
      t.string :addressable_type
      t.timestamps
    end
    add_index :likes, :user_id
    add_index :likes, :addressable_id
  end
end
