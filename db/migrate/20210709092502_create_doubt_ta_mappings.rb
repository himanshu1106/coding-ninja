class CreateDoubtTaMappings < ActiveRecord::Migration[6.1]
  def change
    create_table :doubt_ta_mappings do |t|
      t.integer :doubt_id
      t.integer :solver_id
      t.integer :status
      t.timestamps
    end
  end
end
