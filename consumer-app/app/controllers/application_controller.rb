class ApplicationController < ActionController::Base
  helper_method :current_user, :auth_url
  before_action :remove_token_from_url

  private

  def current_user
    @current_user ||= verify_user
  end

  def verify_user
    if params.has_key?(:token)
      uri = URI.parse(Rails.configuration.sso[:verify_url])
      uri.query = URI.encode_www_form(
        {
          token: params[:token]
        }
      )
      res = Net::HTTP.get(uri)
      json = JSON.parse(res, symbolize_names: true)
      puts json
      session[:email] = json[:email]
    end
    User.find_or_create_by!(email: session[:email]) if session.has_key? :email
  end

  def auth_url
    "#{Rails.configuration.sso[:auth_url]}?redirect_url=#{request.original_url}"
  end

  def remove_token_from_url
    redirect_to request.path, params: params.merge({ token: nil }) if current_user && params.has_key?(:token)
  end

  def require_user!
    return if current_user

    redirect_to auth_url, flash: { error: 'You are not authenticated' }
  end

  def go_to_dashboard_if_authenticated!
    return redirect_to dashboard_path if current_user
  end
end
