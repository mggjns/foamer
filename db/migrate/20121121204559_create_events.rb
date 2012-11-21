class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :google_id
      t.string :g_created
      t.string :g_updated
      t.string :summary
      t.string :location
      t.datetime :start
      t.datetime :end
      t.string :timezone
      t.float :latitude
      t.float :longitude
      t.integer :user_id

      t.timestamps
    end
  end
end
