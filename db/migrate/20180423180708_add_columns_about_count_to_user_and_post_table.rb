class AddColumnsAboutCountToUserAndPostTable < ActiveRecord::Migration[5.1]
  def change

    add_column :users, :comments_count, :integer, default: 0
    add_column :users, :posts_count, :integer, default: 0
    add_column :users, :commented_posts_count, :integer, default: 0
    add_column :posts, :comments_count, :integer, :default => 0
    add_column :posts, :commented_users_count, :integer, default: 0
    add_column :posts, :users_count, :integer, :default => 0

  end
end
