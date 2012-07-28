class AddUserIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :user_id, :int
    add_column :reports, :title, :string
    add_column :reports, :body, :string
  end
end
