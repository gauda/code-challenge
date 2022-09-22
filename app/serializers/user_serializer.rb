class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :status
end
