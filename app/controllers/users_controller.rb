class UsersController < ApiController
    include UsersHelper  

    before_action :extract_params

    def home
      @doubts = get_home_data        
    end

    def login_form
      redirect_to "/users/home" if @user.present? && @user.is_session_present?(session)
    end

    def login
      @user, @session,  @error_message = User.validate_login(@user_name, @password)
      if @error_message.present? 
          flash[:error_message] = @error_message
          redirect_to "/users/login" and return
      end
      session["current_user_id"] = @user.id
      redirect_to "/users/home"
    end

    def logout
      destroy_session
      redirect_to "/users/login"
    end

    
    private

    def extract_params
        @user_name = params['username']
        @password = params['password']
    end

end
