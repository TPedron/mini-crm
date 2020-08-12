class TagSerializer
  include FastJsonapi::ObjectSerializer

  set_type 'Tag'
  set_key_transform :camel_lower
  set_id :uuid

  attributes :name
end
