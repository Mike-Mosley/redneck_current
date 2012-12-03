class SupportMailer < ActionMailer::Base
  default :from => "no-reply@theredneckroundup.com",
      :content_type => 'text/html',
      :to => 'michael.mosley@gmail.com',
      :cc => 'theredneckroundup@gmail.com'
  def send_feedback(user, description)
    @subject = "Feedback"
    @user = user
    @body = "FROM: #{user.handle}<br/>DESCRIPTION: #{description}"
    mail(:subject => @subject, :body => @body)
  end

end
