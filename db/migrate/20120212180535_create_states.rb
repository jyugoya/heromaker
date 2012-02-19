class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :user_id
      t.date :c_date
      t.date :turn_end
      # t.integer :character_id
      
      t.integer :c_command_id
      t.integer :c_event_id

      t.timestamps
    end
  end
end
