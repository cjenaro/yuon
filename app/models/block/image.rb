class Block::Image < ApplicationRecord
  has_one :block, as: :blockable
  has_one_attached :image

  validates :image, presence: true

  def image_url
    image&.attached? && Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end
end