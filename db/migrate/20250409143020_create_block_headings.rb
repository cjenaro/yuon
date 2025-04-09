class CreateBlockHeadings < ActiveRecord::Migration[8.0]
  def change
    create_table :block_headings do |t|
      t.integer :level
      t.string :content

      t.timestamps
    end
  end
end
