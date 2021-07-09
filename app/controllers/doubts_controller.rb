class DoubtsController < ApiController

    before_action :validate_resolve_params, :authorize_user, only: [:resolve]


    def create
        doubt, error = Doubt.create_new(params.permit(:title, :description), @user)
        if error.present?
            flash[:error_message] = error
            redirect_to "/doubts/new" and return
        end
        redirect_to "/users/home" and return
    end

    def accept
        doubt_id = params["id"]
        @doubt = Doubt.active.for_id(doubt_id).includes(:user, :solver).take
        if !@doubt.present?
            flash[:error_message] = "Doubt not found !! Doubt has been solved or removed."
            redirect_to "/users/login"
            return
        end
        @doubt.mark_accepted
        render "doubts/show"
    end

    def index
        @doubts = Doubt.active.order(created_at: :desc)

    end

    def new
        
    end

    def resolve
        @doubt = Doubt.in_progress.find_by_id(@doubt_id)
        render_json_error("doubt_not_found") and return unless @doubt.present?
        @doubt.mark_resolve(@solution, @user)
        render "doubts/show"
    end

    def escalate
        @doubt_id = params["id"]
        @doubt = Doubt.in_progress.find_by_id(@doubt_id)
        render_json_error("doubt_not_found") and return unless @doubt.present?
        @doubt.mark_escalated
        redirect_to "/doubts"
    end

    def stats
      total_doubts = Doubt.active_or_resolved.size
      solved_doubts = Doubt.solved.size
      avg_time = Doubt.solved.select("avg(doubts.solved_at - doubts.created_at) as time_val").last.time_val  

    end

    private

    def authorize_user
        if !@user.is_ta?
            render_json_error("unauthorized_access", "Log in as TA to solve problem") and return
        end
    end

    def validate_resolve_params
      @doubt_id = params["id"]
      @solution = params["answer"]
      render_json_error("insufficient_parameters") unless (@doubt_id.present? && @solution.present?)
    end
end
