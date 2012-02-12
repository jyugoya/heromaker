class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :player
      t.date :current

      t.timestamps
    end
  end
end
