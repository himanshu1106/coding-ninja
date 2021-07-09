class UsersController < ApiController
    
    before_action :extract_params

    def login
        @user, @session,  @error_message = User.validate_login(@user_name, @password)
        if @error_message.present? 
            flash[:error_message] = @error_message
            redirect_to "/users/login"
            return
        end
        session["current_user_id"] = @user.id
        redirect_to "/users/home"
    end

    def logout
      destroy_session
      redirect_to "/users/login"
    end

    def home
      @doubts = get_home_data        
    end

    def login_form
        redirect_to "/users/home" if @user.present? && @user.is_session_present?(session)
    end

    private

    def extract_params
        @user_name = params['username']
        @password = params['password']
    end

    def get_home_data
        @doubts = Doubt.active_or_resolved.order(created_at: :desc).includes(:user, comments: :user)
    end

    def get_ta_home_data

    end

    def get_teacher_home_data

    end
end
