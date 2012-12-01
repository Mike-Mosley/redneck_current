class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :friend_id
      t.integer :user_id
      t.timestamps
    end
    add_index :friends, :friend_id
    add_index :friends, :user_id
  end
end
