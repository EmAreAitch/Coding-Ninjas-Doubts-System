class TeachingAssistant < User
  has_one :ta_stat, foreign_key: 'ta_id', inverse_of: "ta", dependent: :destroy
  has_many :doubt_assignments, foreign_key: 'ta_id', inverse_of: "ta", dependent: :destroy

   after_create :create_ta_stat_record
   after_update :update_ta_stat_name, if: :saved_change_to_name?
   
   private
   
   def create_ta_stat_record
     create_ta_stat!(
       name: self.name,
       ta: self
     )
   end
   
   def update_ta_stat_name
     TaStat.where(ta: self).update!(name: self.name)
   end
end
