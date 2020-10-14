class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers
  helper_method :current_user

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    return if current_user
    save_passwordless_redirect_location!(User)
    redirect_to root_path, flash: { error: 'You are not authenticated' }
  end

  def go_to_dashboard_if_authenticated!
    redirect_to dashboard_path if current_user
  end
end
