class AddPublishedToGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :published, :boolean
  end
end
