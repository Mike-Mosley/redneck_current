class CreateHollers < ActiveRecord::Migration
  def change
    create_table :hollers do |t|
      t.integer :user_id
      t.string :title
      t.string :type
      t.integer :post_settings
      t.timestamps
    end
  end
end
