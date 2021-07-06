class Doubt < ApplicationRecord
    belongs_to :User
    has_one :Solver, class: 'User', foreign_key: 'solved_by'
end
