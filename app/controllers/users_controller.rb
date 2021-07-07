class UsersController < ApiController
    
    before_action :extract_params

    def login
        @user, @session,  error_message = User.validate_login(@user_name, @password)
        render_json_error(error_message) and return if error_message.present?
        render json: {"sucess": true, "access_token": @session.access_token } and return
    end

    def logout
        Session.destroy(@session)
        render json: {"sucess": true}
    end

    def home
        render json: {"home": true}
    end

    private

    def extract_params
        @user_name = params['user_name']
        @password = params['password']

    end
end
