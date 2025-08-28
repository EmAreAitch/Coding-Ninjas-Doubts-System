class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # STI default
  after_initialize :set_default_type, if: :new_record?

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 50 }, allow_blank: true
  
  validates :type, presence: true, inclusion: { in: %w[Student Admin TA] }
  has_many :doubts, dependent: :destroy
  has_many :comments, dependent: :destroy
  private

  def set_default_type
    self.type ||= "Student"
  end
end
