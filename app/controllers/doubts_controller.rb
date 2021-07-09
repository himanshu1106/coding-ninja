class DoubtsController < ApiController

    before_action :validate_resolve_params, :authorize_user, only: [:resolve]


    def create
        # byebug
        doubt, error = Doubt.create_new(params.permit(:title, :description), @user)
        # render_json_error(error) and return if error.present?
        
        redirect_to "/users/home"

        # render json: ActiveModelSerializers::SerializableResource.new(doubt).as_json and return
    end

    def show
        doubt_id = params["id"]
        doubt = Doubt.active_or_resolved.for_id(doubt_id)
        render_json_error("doubt_not_found") and return unless doubt.present?
        # render json: ActiveModelSerializers::SerializableResource.new(doubt).as_json and return
    end

    def index
        @doubts = Doubt.active.order(created_at: :desc)
        # render json: ActiveModelSerializers::SerializableResource.new(@doubts).as_json and return
    end

    def new
        
    end

    def resolve
        doubt = Doubt.active.find_by_id(@doubt_id)
        render_json_error("doubt_not_found") and return unless doubt.present?
        doubt.mark_resolve(@solution, @user)
        render json: ActiveModelSerializers::SerializableResource.new(doubt).as_json and return
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
      @solution = params["solution"]
      render_json_error("insufficient_parameters") unless (@doubt_id.present? && @solution.present?)
    end
end
