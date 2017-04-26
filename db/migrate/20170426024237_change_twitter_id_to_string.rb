class ChangeTwitterIdToString < ActiveRecord::Migration
  def change
    change_column :articles, :twitter_status_id, :string
  end
end
