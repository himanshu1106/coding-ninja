class DoubtTaMapping < ApplicationRecord

  belongs_to :doubt
  belongs_to :solver, class_name: 'User', foreign_key: 'solver_id', primary_key: 'id'

  scope :for_solver_id, -> (solver_id){where("solver_id = (?)", solver_id)}

  enum status: [:in_active, :active, :escalated, :done]

  def self.create_mapping user, doubt_id
    dtmapping = DoubtTaMapping.find_or_initialize_by(doubt_id: doubt_id, solver_id: user.id)
    dtmapping.status = :active
    dtmapping.save
    dtmapping
  end

  def self.get_escalated_count
    DoubtTaMapping.where(status: :escalated).select("count(distinct(doubt_id)) as escalated_count").group("doubt_ta_mappings.id").size.keys.size
  end
end
