class Block::Heading < ApplicationRecord
  has_one :block, as: :blockable
  
  validates :content, presence: true
  validates :level, inclusion: { in: 1..6 }
end
