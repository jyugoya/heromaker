class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer  :state_id
      t.string   :name, :null => false, :default => "", :limit => 32
      t.date     :s_date
      t.date     :e_date
      t.integer  :probability
      t.string   :message, :limit => 512

      t.timestamps
    end

    add_index :events, :name, :unique => true
  end
end
