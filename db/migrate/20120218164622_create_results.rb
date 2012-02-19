class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :state_id
      t.string :r_string

      t.timestamps
    end
  end
end
