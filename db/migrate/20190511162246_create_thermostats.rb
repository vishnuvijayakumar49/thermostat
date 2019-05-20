class CreateThermostats < ActiveRecord::Migration[5.2]
  def change
    create_table :thermostats do |t|
      t.string :household_token
      t.text :location

      t.timestamps
    end
    add_index :thermostats, :household_token
  end
end
