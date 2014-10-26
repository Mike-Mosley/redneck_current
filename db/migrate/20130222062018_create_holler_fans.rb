class CreateHollerFans < ActiveRecord::Migration
  def change
    create_table :holler_fans do |t|
      t.integer :holler_id
      t.integer :user_id
      t.timestamps
    end
  end
end
