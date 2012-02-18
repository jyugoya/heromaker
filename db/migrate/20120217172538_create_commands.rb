class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.integer :state_id
      t.string :name, :limit => 32

      t.timestamps
    end
  end
end
