class ApiController < ApplicationController

  before_action :authenticate_api
  
  def authenticate_api
    controller_name = params["controller"]
    action_name = params["action"]
    if(API_AUTH_CONFIG[controller_name][action_name] == 1)
      authenticate_session
    end
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
    access_token = request.headers["access-token"]
    @session =  Session.active.for_token(access_token).last
    # byebug
    render_json_error("unauthorized_access") and return unless @session.present?
    # byebug
    @user = @session.user
  end
end
