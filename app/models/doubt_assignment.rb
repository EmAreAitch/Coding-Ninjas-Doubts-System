class DoubtAssignment < ApplicationRecord
  belongs_to :doubt
  belongs_to :ta, class_name: "TeachingAssistant"

  enum :status, [ :accepted, :escalated, :resolved]  

  has_rich_text :answer

  validate :no_existing_accepted_or_resolved_assignment, on: :create
  validate :status_can_only_change_from_accepted, on: :update
  validate :answer_only_allowed_when_accepted
  before_save :auto_resolve_if_answer_present
  after_create :mark_doubt_as_accepted
  after_update :update_doubt_status_and_acceptance
    
  private

  def auto_resolve_if_answer_present
    if answer.present?
      self.status = "resolved" 
      self.resolution_time = Time.current - created_at      
    end
  end

  def status_can_only_change_from_accepted
    # Skip if status is not being changed
    return unless will_save_change_to_status?

    # Prevent update if current status is not accepted
    if status_was != "accepted"
      errors.add(:status, "can only be changed if the current status is accepted")
    end
  end  

  def answer_only_allowed_when_accepted
    if answer.present? && !accepted?
      errors.add(:answer, "can only be added or updated when status is accepted")
    end
  end

  def no_existing_accepted_or_resolved_assignment
    existing = DoubtAssignment.where(doubt: doubt, status: [:accepted, :resolved])
    .or(DoubtAssignment.where(ta: ta, status: :accepted))
    .or(DoubtAssignment.where(ta: ta, doubt: doubt))
    .exists?
    
    if existing
      errors.add(:base, "This doubt already has an accepted or resolved assignment")
    end
  end

  def mark_doubt_as_accepted
    if accepted?
      doubt.update!(accepted: true)
      TaStat.where(ta: ta).update_counters(doubts_accepted: 1)
    elsif resolved?
      doubt.update!(accepted: true, status: :resolved, resolution_time: Time.current - doubt.created_at)
      TaStat.where(ta: ta).update_counters(doubts_accepted: 1, doubts_resolved: 1, sum_activity_time: resolution_time)
    end
  end

  def update_doubt_status_and_acceptance
    if saved_change_to_status? && escalated?
      doubt.update!(accepted: false, status: :escalated)
      TaStat.where(ta: ta).update_counters(doubts_escalated: 1)
    elsif saved_change_to_status? && resolved?
      doubt.update!(accepted: true, status: :resolved, resolution_time: Time.current - doubt.created_at)
      TaStat.where(ta: ta).update_counters(doubts_resolved: 1, sum_activity_time: resolution_time)
    end
  end
end
