class CreateProgresses < ActiveRecord::Migration[6.0]
  def change
    create_table :progresses do |t|
      t.string :user_id, null: false
      t.string :goal_id, null: false
      t.string :body, null: false
      t.string :progress_image

      t.timestamps
    end
  end
end
