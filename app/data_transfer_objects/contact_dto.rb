class ContactDto
  attr_accessor :uuid, :first_name, :last_name, :email, :tag_names

  def initialize(hash_params)
    @uuid = hash_params.dig(:data, :id) || hash_params.dig(:id)

    attributes = hash_params.dig(:data, :attributes) || {}

    @first_name = attributes.dig(:first_name)
    @last_name = attributes.dig(:last_name)
    @email = attributes.dig(:email)
    @tag_names = attributes.dig(:tags) # Expecting array of String
  end
end
