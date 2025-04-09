class Block::Text < ApplicationRecord
  has_one :block, as: :blockable
  
  validates :content, presence: true
end
