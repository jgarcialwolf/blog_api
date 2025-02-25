class Post < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["category", "content", "created_at", "id", "tags", "title", "updated_at"]
  end
end
