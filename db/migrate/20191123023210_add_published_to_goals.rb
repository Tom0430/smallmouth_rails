class AddPublishedToGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :published, :boolean, default: true, null: false
  end
end
