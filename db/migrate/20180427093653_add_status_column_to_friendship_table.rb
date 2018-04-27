class AddStatusColumnToFriendshipTable < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :status, :boolean, default: false, null: false
  end
end
