class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :kind
      t.string :etag
      t.string :google_id
      t.string :summary
      t.string :description
      t.string :time_zone
      t.integer :color_id
      t.string :background_color
      t.string :foreground_color
      t.boolean :selected
      t.string :access_role
      t.boolean :active

      t.timestamps
    end
  end
end
