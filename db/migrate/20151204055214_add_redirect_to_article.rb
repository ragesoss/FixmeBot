class AddRedirectToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :redirect, :boolean
  end
end
