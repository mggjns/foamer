class AddMoreTokenColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_expires_at, :time
    add_column :users, :refresh_token, :string
  end
end
