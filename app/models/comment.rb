class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

   validates :body, presence: true,
                   length: { minimum: 3, maximum: 500, allow_blank: true }
end
