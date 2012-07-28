class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null => false
      t.string :password_digest, :null => false
      t.string :email
      t.string :phone_number
      t.timestamps
    end
  end
end
