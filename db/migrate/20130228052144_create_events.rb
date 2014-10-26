class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :holler_id
      t.datetime :event_date
      t.boolean :active
      t.string :event_name
      t.text :description
      t.timestamps
    end
  end
end
