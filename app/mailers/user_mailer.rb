class UserMailer < ActionMailer::Base
  default :from => "no-reply@theredneckroundup.com",
      :content_type => 'text/html',
      :cc => 'theredneckroundup@gmail.com'
  def email_address_confirmation(user)
    @subject = "Please Confirm Your E-Mail Address"
    @user = user
    @body = render_to_string(:template => 'user/email_confirmation.html.haml')
    mail(:to => user.username, :subject => @subject, :body => @body)
  end

  def password_reset(user)
    @subject = "Redneck Roundup User Information"
    @user = user
    logger.info @user.inspect
    @body = render_to_string(:template => 'user/reset_password.html.haml')
    mail(:to => user.username, :subject => @subject, :body => @body)
  end
end
