class DoubtSerializer < ActiveModel::Serializer
  
  attributes :id , :title, :description, :user_id, :status, :solved_by, :solved_at, :solution
end
