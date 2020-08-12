class ContactDto
  attr_accessor :first_name, :last_name, :email

  def initialize(hash_params)
    attributes = hash_params.dig(:data, :attributes) || {}

    @first_name = attributes.dig(:first_name)
    @last_name = attributes.dig(:last_name)
    @email = attributes.dig(:email)
  end
end
