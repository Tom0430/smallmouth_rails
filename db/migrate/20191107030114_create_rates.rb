class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.string :user_id
      t.string :goal_id
      t.string :quantity

      t.timestamps
    end
  end
end
