class TagDto
  attr_accessor :name

  def initialize(hash_params)
    attributes = hash_params.dig(:data, :attributes) || {}

    @name = attributes.dig(:name)
  end
end
