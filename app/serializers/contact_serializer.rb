class ContactSerializer
  include FastJsonapi::ObjectSerializer

  set_type 'Contact'
  set_key_transform :camel_lower
  set_id :uuid

  attributes :first_name, :last_name, :email
end
