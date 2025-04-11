class Block::Code < ApplicationRecord
  has_one :block, as: :blockable

  enum :language, {
    html: "html",
    css: "css",
    javascript: "javascript",
    typescript: "typescript",
    ruby: "ruby",
    python: "python",
    java: "java",
    csharp: "csharp",
  }

  validates :language, presence: true
  validates :content, presence: true
end