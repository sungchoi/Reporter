class AddUserIdToReport < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.integer :user_id
    end
  end
end
