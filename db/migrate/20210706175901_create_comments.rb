class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :user_id,  references: :users
      t.integer :doubt_id, references: :doubts
      t.string :comment, :null=>false
      t.timestamps
    end
  end
end
