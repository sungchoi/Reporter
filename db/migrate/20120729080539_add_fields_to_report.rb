class AddFieldsToReport < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.string :image_url
      t.string :live_stream
    end
  end
end
