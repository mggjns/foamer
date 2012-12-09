class AddTravelModeToUser < ActiveRecord::Migration
  def change
    add_column :users, :travel_mode, :string
  end
end
