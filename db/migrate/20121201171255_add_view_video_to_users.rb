class AddViewVideoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :view_video, :boolean, :default => false
  end
end
