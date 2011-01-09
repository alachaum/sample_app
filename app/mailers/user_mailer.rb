class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def follower_notification(user, follower)
    @user = user
    @follower = follower
    mail(:to => @user.email, :subject => "New follower!")
  end
end
