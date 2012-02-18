class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :state_id
      t.string :name, :limit => 32
      t.date :birthday

      t.timestamps
    end
  end
end
