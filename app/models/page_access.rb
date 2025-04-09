class PageAccess < ApplicationRecord
  belongs_to :user
  belongs_to :page
  
  validates :user_id, uniqueness: { scope: :page_id }
end 