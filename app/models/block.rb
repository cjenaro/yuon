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
      
      image_file = attributes.delete(:image) if type.to_s == 'image' && attributes[:image].present?
      valid_attributes = attributes.slice(*klass.attribute_names)
      self.blockable = klass.new(valid_attributes)
      
      if image_file && self.blockable.respond_to?(:image)
        self.blockable.image.attach(image_file)
      end
    else
      raise ArgumentError, "Unknown block type: #{type}"
    end
  end
end
