class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.integer :command_id
      t.string :p_name, :limit => 32
      t.integer :e_value

      t.timestamps
    end
  end
end
