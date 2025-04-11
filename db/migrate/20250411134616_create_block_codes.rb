class CreateBlockCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :block_codes do |t|
      t.string :language, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
