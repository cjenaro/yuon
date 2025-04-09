module Block
  def self.table_name_prefix
    "block_"
  end
end

class Block < ApplicationRecord
  belongs_to :page
  acts_as_list scope: :page
  
  delegated_type :blockable, types: %w[Block::Text Block::Heading]
  
  validates :position, presence: true
end
