class UserMailer < ApplicationMailer
  def updated
    @user = params[:user]

    mail to: @user.email, subject: 'Your status changed'
  end

  def deleted
    @user = params[:user]

    mail to: @user.email, subject: 'Your user is deleted'
  end
end
