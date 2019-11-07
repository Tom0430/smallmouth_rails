class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :user_id
      t.string :goal_id
      t.string :body

      t.timestamps
    end
  end
end
