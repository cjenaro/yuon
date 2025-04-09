class CreateBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :blocks do |t|
      t.references :page, null: false, foreign_key: true
      t.references :blockable, polymorphic: true, null: false
      t.integer :position

      t.timestamps
    end
  end
end
