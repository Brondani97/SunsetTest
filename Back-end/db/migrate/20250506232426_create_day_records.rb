class CreateDayRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :day_records do |t|
      t.references :location, null: false, foreign_key: true
      t.date :date
      t.datetime :sunrise_time
      t.datetime :sunset_time
      t.datetime :golden_hour_start
      t.datetime :golden_hour_end

      t.timestamps
    end
  end
end
