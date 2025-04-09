class Block::Text < ApplicationRecord
  has_one :block, as: :blockable, dependent: :destroy
  
  validates :content, presence: true
end
