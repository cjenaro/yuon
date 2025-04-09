class Page < ApplicationRecord
  belongs_to :user
  belongs_to :parent_page, class_name: "Page", optional: true
  
  has_many :blocks, dependent: :destroy
  has_many :child_pages, class_name: "Page", foreign_key: :parent_page_id, dependent: :destroy
  
  has_many :page_accesses, dependent: :destroy
  has_many :shared_users, through: :page_accesses, source: :user
  
  validates :title, presence: true
end
