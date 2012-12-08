class AddTravelModeToUser < ActiveRecord::Migration
  def change
    add_column :users, :travel_mode, :string, :default => "DRIVING"
  end
end
