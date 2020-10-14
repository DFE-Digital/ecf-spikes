Passwordless.parent_mailer = "ActionMailer::Base"

Passwordless.after_session_save = lambda do |session, request|
  # Default behavior is
  Passwordless::Mailer.magic_link(session).deliver_now

  # You can change behavior to do something with session model. For example,
  # session.authenticatable.send_sms
end