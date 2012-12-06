class AddRecurringEventIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :recurringEventId, :string
  end
end
