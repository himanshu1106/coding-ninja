class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, :null => false
      t.string :password_digest,  :null=>false
      t.integer :status, :default => 1
      t.integer :login_type, :default => 0
      t.timestamps
    end
  end
end
