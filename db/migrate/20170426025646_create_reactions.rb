class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.string :twitter_status_id
      t.string :original_status
      t.integer :article_id
      t.datetime :responded_at
    end
    add_index :reactions, :twitter_status_id, unique: true
  end
end
