class User < ActiveRecord::Base
    has_secure_password

    enum status: [:in_active, :active]
    enum login_type: [:student, :teacher, :teaching_assistant]

    def self.validate_login(user_name, password)
        user = User.find_by(first_name: user_name)
        return nil, "user_not_found" unless user.present?
        return nil, "incorrect_password" unless user.authenticate(password)
        # session[:current_user_id] = user.id
        return user, nil
    end
end
