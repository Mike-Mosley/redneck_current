class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :created_by
      t.string :addressable_type
      t.integer :addressable_id
      t.string :post
      t.integer :like_count
      t.integer :comment_count
      t.timestamps
    end
    add_index :posts, :created_by
    add_index :posts, :addressable_id
  end
end