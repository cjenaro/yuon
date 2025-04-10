class Block < ApplicationRecord
  belongs_to :page
  acts_as_list scope: :page
  
  belongs_to :blockable, polymorphic: true, dependent: :destroy
  
  validates :position, presence: true

  def self.types
    @types ||= begin
      # Get all files in the block directory
      block_path = Rails.root.join('app', 'models', 'block')
      
      # Extract type names from filenames, excluding the block.rb itself
      Dir.glob("#{block_path}/*.rb").map do |file|
        File.basename(file, '.rb')
      end.reject { |name| name == 'block' || name.include?('/') }
    end
  end

  def build_blockable(type, attributes = {})
    class_name = "Block::#{type.to_s.camelize}"
    
    if Object.const_defined?(class_name)
      klass = class_name.constantize
      valid_attributes = attributes.slice(*klass.attribute_names)
      self.blockable = klass.new(valid_attributes)
    else
      raise ArgumentError, "Unknown block type: #{type}"
    end
  end

  def text?
    blockable_type == 'Block::Text'
  end

  def heading?
    ['Block::H1', 'Block::H2', 'Block::H3'].include?(blockable_type)
  end

  def text
    blockable if text?
  end

  def heading
    blockable if heading?
  end
end
