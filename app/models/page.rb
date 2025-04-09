class Page < ApplicationRecord
  belongs_to :user
  belongs_to :parent_page
end
