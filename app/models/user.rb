class User < ActiveRecord::Base
    has_secure_password

    enum status: [:in_active, :active]
    enum login_type: [:student, :teacher, :teaching_assistant]

    def self.validate_login(user_name, password)
        user = User.find_by(first_name: user_name)
        return nil, nil, "User Not Found" unless user.present?
        return nil, nil, "Incorrect Password" unless user.authenticate(password)
        session = Session.get_new_session(user)
        return user, session, nil
    end


    def is_student?
        return self.login_type == "student"
    end

    def is_teacher?
        return self.login_type == "teacher"
    end

    def is_ta?
        return self.login_type == "teaching_assistant"
    end

    def is_session_present?(session)
        return session["current_user_id"].present? && session["current_user_id"]==self.id
    end
end
