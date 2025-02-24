class PostSerializer < BaseSerializer
  attributes :id, :title, :content, :category, :tags, :created_at, :updated_at
end
