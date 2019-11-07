class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.string :user_id
      t.string :title
      t.string :detail
      t.boolean :achieved
      t.datetime :limit_time

      t.timestamps
    end
  end
end
