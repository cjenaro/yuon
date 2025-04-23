class Page < ApplicationRecord
  belongs_to :user
  belongs_to :parent_page, class_name: "Page", optional: true

  has_many :blocks, dependent: :destroy
  has_many :child_pages, class_name: "Page", foreign_key: :parent_page_id, dependent: :destroy

  has_many :page_accesses, dependent: :destroy
  has_many :shared_users, through: :page_accesses, source: :user

  validates :title, presence: true

  # group list items together
  def grouped_blocks
    blocks_array = blocks.order(:position).to_a
    grouped_blocks = []
    current_group = nil
    current_type = nil

    blocks_array.each do |block|
      blockable_type = block.blockable_type

      if blockable_type.in?([ "Block::OrderedListItem", "Block::UnorderedListItem" ])
        if current_type != blockable_type
          grouped_blocks << current_group if current_group.present?

          current_group = { type: blockable_type, blocks: [] }
          current_type = blockable_type
        end

        current_group[:blocks] << block
      else
        if current_group.present?
          grouped_blocks << current_group
          current_group = nil
          current_type = nil
        end

        grouped_blocks << block
      end
    end

    grouped_blocks << current_group if current_group.present?

    grouped_blocks
  end
end
