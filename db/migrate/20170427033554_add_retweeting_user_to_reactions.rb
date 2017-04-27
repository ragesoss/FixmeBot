class AddRetweetingUserToReactions < ActiveRecord::Migration
  def change
    add_column :articles, :retweeting_user, :string
    remove_index :reactions, :twitter_status_id
    add_index :reactions, [:retweeting_user, :original_status], unique: true
  end
end
