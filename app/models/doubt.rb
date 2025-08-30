class Doubt < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order(created_at: :asc) }, as: :commentable, dependent: :destroy
  has_many :doubt_assignments, dependent: :destroy
  has_one :resolved_assignment, -> { where(status: :resolved) }, 
                     class_name: 'DoubtAssignment', dependent: :destroy
                                
  has_rich_text :description

  enum :status, [ :pending, :escalated, :resolved]

  validates :title, presence: true, length: { maximum: 200 }

  validate :description_must_be_present

  def available_for_ta?(ta)
    return false unless ta.is_a? TeachingAssistant
    
    !accepted? && DoubtAssignment.new(doubt: self, ta:).valid?
  end

  private

  def description_must_be_present
    if description.blank? || description.body.blank?
      errors.add(:description, "can't be blank")
    elsif description.body.to_plain_text.strip.length < 20
       errors.add(:description, "must be at least 20 characters")
    end
  end
end
