class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :latest_revision
      t.datetime :latest_revision_datetime
      t.string :rating
      t.float :wp10
      t.float :average_views
      t.date :average_views_updated_at

      t.timestamps null: false
    end
  end
end
