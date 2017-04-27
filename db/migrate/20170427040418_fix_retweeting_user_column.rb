class FixRetweetingUserColumn < ActiveRecord::Migration
  def change
    remove_column :articles, :retweeting_user, :string
    add_column :reactions, :retweeting_user, :string
    remove_index :reactions, [:retweeting_user, :original_status]
    add_index :reactions, [:retweeting_user, :original_status], unique: true
  end
end
