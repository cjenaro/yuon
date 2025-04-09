class Page < ApplicationRecord
  belongs_to :user
  belongs_to :parent_page, class_name: "Page", optional: true
  
  has_many :blocks, dependent: :destroy
  has_many :child_pages, class_name: "Page", foreign_key: :parent_page_id, dependent: :destroy
  
  validates :title, presence: true
end
