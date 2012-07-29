class CreateReports < ActiveRecord::Migration
  def change
    drop_table :users if self.table_exists?("users")
    create_table :reports do |t|
      t.string :location
      t.float :latitude
      t.float :longitude
      t.string :report_type
      t.string :description

      t.timestamps
    end
  end
end
