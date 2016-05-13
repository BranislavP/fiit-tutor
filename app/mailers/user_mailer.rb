class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def requested_event(user, subject, event)
    @user = user
    @subject = subject
    @event = event
    mail to: user.email, subject: "Requested event created"
  end
end