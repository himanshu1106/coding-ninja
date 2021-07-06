class CreateDoubts < ActiveRecord::Migration[6.1]
  def change
    create_table :doubts do |t|
      t.integer :user_id, references: :users, :null=>false
      t.string :title, :null=>false
      t.string :description
      t.string :solution
      t.integer :solved_by, references: :users
      t.integer :status
      t.timestamp :solved_at
      t.timestamps
    end
  end
end
