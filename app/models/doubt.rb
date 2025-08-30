class Doubt < ApplicationRecord
  belongs_to :user, class_name: "Student"
  has_many :comments, -> { order(created_at: :asc) }, as: :commentable, dependent: :destroy
  has_many :doubt_assignments, dependent: :destroy
  has_one :resolved_assignment, -> { where(status: :resolved) }, 
                     class_name: 'DoubtAssignment', dependent: :destroy
                                
  has_rich_text :description

  enum :status, [ :pending, :escalated, :resolved]

  validates :title, presence: true, length: { maximum: 200 }

  validate :description_must_be_present

  after_save :after_save_method
  after_destroy :after_destroy_method

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

  def after_save_method
    h = {}
    h[:doubts_asked] = 1 if previously_new_record?
    
    if saved_change_to_status?
      old, new = status_before_last_save, status
      
      if new == 'resolved' && old != 'resolved'
        h[:doubts_resolved] = 1        
      elsif old == 'resolved' && new != 'resolved'
        h[:doubts_resolved] = -1        
      end
      
      if new == 'escalated' && old != 'escalated'
        h[:doubts_escalated] = 1
      elsif old == 'escalated' && new != 'escalated'
        h[:doubts_escalated] = -1
      end
    end
    
    if saved_change_to_resolution_time? && resolved?
      diff = resolution_time.to_i - resolution_time_before_last_save.to_i
      h[:sum_resolution_seconds] = (h[:sum_resolution_seconds] || 0) + diff if diff != 0
    end
    
    DoubtStat.update_counters(h) if h.any?
  end
  
  def after_destroy_method
    h = { doubts_asked: -1 }
    h[:doubts_resolved] = -1 if resolved?
    h[:doubts_escalated] = -1 if escalated?
    h[:sum_resolution_seconds] = -resolution_time if resolved? && resolution_time.present?
    DoubtStat.update_counters(h)
  end
  
end
