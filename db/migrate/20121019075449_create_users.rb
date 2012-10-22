class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :salt
      t.string :cb_name
      t.integer :sex_id
      t.integer :relationship_status_id
      t.date  :date_of_birth
      t.string  :first_name
      t.string  :last_name
      t.string  :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.timestamps
    end

    add_index :users, :username,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end
end
