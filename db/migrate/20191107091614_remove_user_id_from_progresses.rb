class RemoveUserIdFromProgresses < ActiveRecord::Migration[6.0]
  def change

    remove_column :progresses, :user_id, :string
  end
end
