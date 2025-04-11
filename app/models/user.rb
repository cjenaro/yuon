class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :pages, dependent: :nullify

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def accessible_pages
    Page.left_joins(:page_accesses)
        .where("pages.user_id = ? OR pages.is_public = ? OR page_accesses.user_id = ?",
               id, true, id)
        .distinct
  end
end
