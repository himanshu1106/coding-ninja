class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :doubt


    def self.create_comment params, user
        comment = Comment.new(user_id: user.id)
        comment.comment = params["comment"]
        comment.doubt_id = params["doubt_id"]
        comment.save
        comment
    end
end
