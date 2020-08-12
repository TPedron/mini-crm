class ContactSerializer
  include FastJsonapi::ObjectSerializer

  set_type 'Contact'
  set_key_transform :camel_lower
  set_id :uuid

  attributes :first_name, :last_name, :email

  attribute :tags do |contact|
    contact.tag_names # NOTE: Returns Array of String
  end
end
