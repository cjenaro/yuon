class CreateBlockListItems < ActiveRecord::Migration[8.0]
  def change
    create_table :block_list_items do |t|
      t.string :list_type
      t.text :content

      t.timestamps
    end
  end
end
