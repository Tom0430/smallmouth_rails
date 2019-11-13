class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.string :user_id, null: false
      t.string :title, null: false
      t.string :detail, null: false
      t.boolean :achieved, default: false, null: false
      t.datetime :limit_time, null: false

      t.timestamps
    end
  end
end
