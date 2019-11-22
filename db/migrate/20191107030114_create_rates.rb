class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.string :user_id, null: false
      t.string :goal_id, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
