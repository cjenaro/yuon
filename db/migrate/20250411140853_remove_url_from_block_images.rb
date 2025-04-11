class RemoveUrlFromBlockImages < ActiveRecord::Migration[8.0]
  def change
    remove_column :block_images, :url, :string
  end
end
