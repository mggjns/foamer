class AddIndexToPlaces < ActiveRecord::Migration
  def change
  	add_index	:places, :user_id, :name => 'user_id_ix'
  end
end
