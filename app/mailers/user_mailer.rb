class UserMailer < ActionMailer::Base
  default from: "group@telephoneix.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  # UserMailer.signup_confirmation(user).deliver
  def signup_confirmation (user)
    @user = user
    mail :to => user.email, :subject => "Sign Up Confirmation"
  end

  def send_password (user, password)
    @user = user
    @password = password
    mail :to => user.email, :subject => "New password"
  end
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   UserMailer.comment_review(user).deliver
  #
  def comment_review ( reviewer, commenter ) 
    @reviewer = reviewer
    @commenter = commenter
    mail :to => reviewer.email, :subject => "Comment Remind"
  end
end
