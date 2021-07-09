class CommentsController < ApiController


    def create
        Comment.create_comment(params.permit(:doubt_id, :comment), @user)
        redirect_to "/users/home"
    end

    def new
    end
end
