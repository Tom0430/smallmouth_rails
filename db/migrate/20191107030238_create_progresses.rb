class CreateProgresses < ActiveRecord::Migration[6.0]
  def change
    create_table :progresses do |t|
      t.string :user_id
      t.string :goal_id
      t.string :body
      t.string :progress_image

      t.timestamps
    end
  end
end
