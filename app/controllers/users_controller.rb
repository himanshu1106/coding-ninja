class UsersController < ApiController
    
    before_action :extract_params

    def login
        @user, error_message = User.validate_login(@user_name, @password)
        render_json_error(error_message) and return if error_message.present?
        # render json: {success: true}
        redirect_to action: "home", id: @user.id
    end

    def home
        
    end

    private

    def extract_params
        @user_name = params['user_name']
        @password = params['password']

    end
end
