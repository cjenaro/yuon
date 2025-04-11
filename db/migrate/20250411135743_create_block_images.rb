class CreateBlockImages < ActiveRecord::Migration[8.0]
  def change
    create_table :block_images do |t|
      t.string :url, null: false
      t.text :content

      t.timestamps
    end
  end
end
