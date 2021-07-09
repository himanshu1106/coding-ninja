class ApiController < ApplicationController

  before_action :authenticate_api, :authorize_api
  
  def authenticate_api
    controller_name = params["controller"]
    action_name = params["action"]
    user_id = session["current_user_id"]
    if user_id.present?
      @user = User.find_by(id: user_id)
      User.current= @user
      if API_AUTH_CONFIG[@user.login_type][controller_name][action_name] != 1
        flash[:error_message] = "Unauthorized Access"
        destroy_session
        redirect_to "/users/login" and return
      end
    elsif (API_AUTH_CONFIG["no_authentication_required"][controller_name][action_name] == 1)
      flash[:error_message] = @error_message
      redirect_to "/users/login" and return
    end
  end

  def authorize_api

  end

  def render_json_error(error_code, extra = "")
    # status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol

    error = {
      title: I18n.t("error_messages.#{error_code}.title"),
      status: I18n.t("error_messages.#{error_code}.code")
    }

    detail = I18n.t("error_messages.#{error_code}.detail", default: '')
    error[:detail] = extra || detail #unless detail.empty?

    render json: error
  end

  private

  def authenticate_session
    # access_token = request.headers["access-token"]
    # @session =  Session.active.for_token(access_token).last
    
    # byebug
    # render_json_error("unauthorized_access") and return unless @session.present?
    # byebug
    # byebug
    # render_json_error('unauthorized_access') and return unless user_id.present?
    
    # render_json_error('unauthorized_access') and return unless @user.present?
  end

  def destroy_session
    session["current_user_id"] = nil
    reset_session
  end
end
