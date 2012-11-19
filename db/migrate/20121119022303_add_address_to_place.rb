class AddAddressToPlace < ActiveRecord::Migration
  def change
    add_column :places, :address, :string
    remove_column :places, :city
    remove_column :places, :state
    remove_column :places, :zip
    remove_column :places, :street
  end
end
