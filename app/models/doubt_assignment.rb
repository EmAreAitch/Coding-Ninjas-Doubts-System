class DoubtAssignment < ApplicationRecord
  belongs_to :doubt
  belongs_to :ta, class_name: "TeachingAssistant"

  enum :status, [ :accepted, :escalated, :resolved]  

  has_rich_text :answer

  validate :no_existing_accepted_or_resolved_assignment, on: :create
  validate :status_can_only_change_from_accepted, on: :update
  validate :answer_only_allowed_when_accepted
  before_save :auto_resolve_if_answer_present
  after_create_commit :mark_doubt_as_accepted
  after_update_commit :update_doubt_acceptance_if_escalated
    
  private

  def auto_resolve_if_answer_present
    self.status = "resolved" if answer.present?
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
    doubt.update(accepted: true) if accepted? || resolved?
  end

  def update_doubt_acceptance_if_escalated
    if saved_change_to_status? && escalated?
      doubt.update(accepted: false)
    end
  end
end
