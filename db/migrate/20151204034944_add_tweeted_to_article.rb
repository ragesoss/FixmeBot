class AddTweetedToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :tweeted, :boolean
  end
end
