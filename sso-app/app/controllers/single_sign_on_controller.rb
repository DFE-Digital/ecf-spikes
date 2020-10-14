class SingleSignOnController < ApplicationController
  include ::Passwordless::ControllerHelpers
  before_action :require_user!, only: [:index]

  def index
    if params.has_key? :redirect_url
      session = build_passwordless_session(current_user).tap {|s|s.save!}
      sign_in(session)
      @current_user = session.authenticatable
      redirect_to "#{params[:redirect_url]}?token=#{session.token}"
    else
      render json: {success: false, error: {message: 'Missing `redirect_url`'}}
    end
  end
  
  def verify
    session = sign_in(passwordless_session)
    user = session.authenticatable
    render json: {success: true, email: user.email}
  end

  private

  def passwordless_session
    @passwordless_session ||= ::Passwordless::Session.find_by!(
      authenticatable_type: 'User',
      token: params[:token]
    )
  end
end
