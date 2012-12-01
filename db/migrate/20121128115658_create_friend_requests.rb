class CreateFriendRequests < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.integer :request_by
      t.integer :request_to
      t.boolean :active
      t.timestamps
    end
    add_index :friend_requests, :request_by
    add_index :friend_requests, :request_to
  end
end
