class AddIndexesToVotes < ActiveRecord::Migration
  def change
    add_index :votes, :report_id
  end
end
