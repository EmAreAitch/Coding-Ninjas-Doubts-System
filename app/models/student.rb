class Student < User
  has_many :doubts, dependent: :destroy, foreign_key: "user_id"
end
