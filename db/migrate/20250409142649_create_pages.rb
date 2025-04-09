class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :parent_page, null: true, foreign_key: { to_table: :pages }

      t.timestamps
    end
  end
end
