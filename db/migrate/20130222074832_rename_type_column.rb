class RenameTypeColumn < ActiveRecord::Migration
  def change
    rename_column :hollers, :type, :category_name
  end
end
