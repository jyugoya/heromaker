class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :user_id
      t.date :current

      t.timestamps
    end
  end
end
