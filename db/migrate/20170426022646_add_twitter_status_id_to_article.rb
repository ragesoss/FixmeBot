class AddTwitterStatusIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :twitter_status_id, :integer
  end
end
