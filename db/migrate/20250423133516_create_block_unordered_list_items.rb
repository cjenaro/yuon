class CreateBlockUnorderedListItems < ActiveRecord::Migration[8.0]
  def change
    create_table :block_unordered_list_items do |t|
      t.text :content

      t.timestamps
    end
  end
end
