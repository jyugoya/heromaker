class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.integer :character_id
      t.string :name, :limit => 32
      t.integer :value

      t.timestamps
    end
  end
end
