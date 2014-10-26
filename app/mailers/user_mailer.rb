class UserMailer < ActionMailer::Base
  default :from => "no-reply@theredneckroundup.com",
      :content_type => 'text/html',
      :bcc => 'theredneckroundup@gmail.com'
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

  def comment_update(users,comment, post)
    user_emails = []
    users.each do |u|
      user =  User.find(u)
      user_emails << user.username
    end
    @subject = "#{comment.user.cb_name} commented on #{post.user.cb_name}'s status"
    @post = post
    @comment = comment
    @body = render_to_string(:template => 'user/someone_commented.html.haml')
    mail(:to => user_emails, :subject => @subject, :body => @body)
  end

  def like_update(like)
    @like = like
    @liker = User.find(like.user_id)
    @post = Post.find(like.addressable_id)
    @user = User.find(@post.created_by)
    @subject = "#{@liker.cb_name} liked your status"
    @body = render_to_string(:template => 'user/someone_liked.html.haml')
    mail(:to => @user.username, :subject => @subject, :body => @body)
  end
end
