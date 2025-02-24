class BaseSerializer < Oj::Serializer
  transform_keys :camelize
end
