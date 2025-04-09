class AddIsPublicToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :is_public, :boolean, default: true
  end
end
