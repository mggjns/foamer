class RemoveDescFromPlace < ActiveRecord::Migration
  def change
  	remove_column :places, :desc
  end
end
