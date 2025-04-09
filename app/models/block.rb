class Block < ApplicationRecord
  belongs_to :page
  acts_as_list scope: :page
  
  belongs_to :blockable, polymorphic: true, dependent: :destroy
  
  validates :position, presence: true

  def build_text(attributes = {})
    self.blockable = Block::Text.new(attributes)
  end

  def build_heading(attributes = {})
    self.blockable = Block::Heading.new(attributes)
  end

  def text?
    blockable_type == 'Block::Text'
  end

  def heading?
    blockable_type == 'Block::Heading'
  end

  def text
    blockable if text?
  end

  def heading
    blockable if heading?
  end
end
