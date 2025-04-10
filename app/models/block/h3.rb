class Block::H3 < ApplicationRecord
  self.table_name = "block_headings"
  
  has_one :block, as: :blockable
  
  validates :content, presence: true
  
  before_create :set_level
  
  private
  
  def set_level
    self.level = 3
  end
end 