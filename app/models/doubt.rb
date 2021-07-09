class Doubt < ApplicationRecord
    belongs_to :user
    has_one :solver, class_name: 'User', foreign_key: 'id', primary_key: 'solved_by'
    has_many :comments
    has_many :doubt_ta_mappings

    scope :for_id, -> (id){where(id: id)}
    scope :active_or_resolved, -> {where(status: [:active, :solved])}
    

    enum status: [:in_active, :active, :in_progress, :solved]

    def self.create_new(params, user)
        doubt = Doubt.new(status: :active, user_id: user.id)
        doubt.title = params["title"]
        doubt.description = params["description"]
        return nil, "operation_failed" unless doubt.save
        return doubt
    end

    def mark_resolve solution, user
        self.solution = solution
        self.solved_by = user.id
        self.solved_at = Time.now
        self.status = "solved"
        self.save
        self.doubt_ta_mappings.active.for_solver_id(user.id).update_all(status: :done)
    end

    def is_solved?
        return self.status == "solved"
    end

    def mark_accepted
        self.status = "in_progress"
        self.save
        dtmapping = DoubtTaMapping.create_mapping(User.current, self.id)
    end

    def mark_escalated
        self.status = "active"
        self.save 
        self.doubt_ta_mappings.active.for_solver_id(User.current.id).update_all(status: :escalated)
    end

end
