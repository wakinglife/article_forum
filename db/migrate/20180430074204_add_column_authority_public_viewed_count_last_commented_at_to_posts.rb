class AddColumnAuthorityPublicViewedCountLastCommentedAtToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :public, :boolean, default: true, null: false
    add_column :posts, :authority, :string, default: "all", null: false
    add_column :posts, :viewed_count, :integer, default: 0
    add_column :posts, :last_commented_at, :datetime
    rename_column :comments, :comment, :content
  end
end
