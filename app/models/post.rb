class Post < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def self.ransackable_attributes(auth_object = nil)
    ["category", "content", "created_at", "id", "tags", "title", "updated_at"]
  end

  mappings do
    indexes :id, type: 'integer'
    indexes :title, type: 'text'
    indexes :content, type: 'text'
    indexes :tags, type: 'keyword'
  end
end
