class AddTopStoryToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :top_story, :boolean, default: false
  end
end
