class TagDto
  attr_accessor :uuid, :name

  def initialize(hash_params)
    attributes = hash_params.dig(:data, :attributes) || {}
    @uuid = attributes.dig(:id) || hash_params.dig(:id)

    @name = attributes.dig(:name)
  end
end
