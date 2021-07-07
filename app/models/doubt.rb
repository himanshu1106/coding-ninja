class Doubt < ApplicationRecord
    belongs_to :user
    has_one :solver, class_name: 'User', primary_key: 'user_id', foreign_key: 'solved_by'

    scope :for_id, -> (id){where(id: id)}
    scope :active_or_resolved, -> {where(status: [:active, :solved])}

    enum status: [:in_active, :active, :solved]

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
    end
end
