class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.string :name
      t.integer :position_type_id
      t.string :url
      t.string :advertisement
      t.timestamps
    end
  end
end
