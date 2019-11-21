class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :user_id, null: false
      t.string :goal_id, null: false
      t.string :body, null: false

      t.timestamps
    end
  end
end
