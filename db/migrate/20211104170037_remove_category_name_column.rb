class RemoveCategoryNameColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :articles, :category_name
  end
end
