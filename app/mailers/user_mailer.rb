class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def follower_notification(user, follower)
    @user = user
    @follower = follower
    mail(:to => @user.email, :subject => "New follower!")
  end
  
  def password_reset_confirmation(password_reset)
    @password_reset = password_reset
    mail(:to => @password_reset.user.email, :subject => "Password reset")
  end
end
