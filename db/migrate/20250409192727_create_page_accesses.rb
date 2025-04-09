class CreatePageAccesses < ActiveRecord::Migration[8.0]
  def change
    create_table :page_accesses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :page, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :page_accesses, [:user_id, :page_id], unique: true
  end
end
