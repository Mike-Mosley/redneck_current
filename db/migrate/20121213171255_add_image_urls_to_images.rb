class AddImageUrlsToImages < ActiveRecord::Migration
  def change
    add_column :images, :thumbnail_url, :string
    add_column :images, :url, :string
  end
end
