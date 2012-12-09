class AddSkipBooleanToEvent < ActiveRecord::Migration
  def change
    add_column :events, :skip, :boolean, :default => true
  end
end
