class AdvertiserMailer < ActionMailer::Base
  default :from => "no-reply@theredneckroundup.com",
      :content_type => 'text/html'

  def ad_request(params)
    logger.info "creating body"
    @body = "Advertising Request From:<br/>"
    @body += "Company: #{params[:company]}<br/>"
    @body += "First Name: #{params[:first_name]}<br/>"
    @body += "Last Name: #{params[:last_name]}<br/>"
    @body += "Phone Number: #{params[:phone_number]}<br/>"
    @body += "E-mail: #{params[:username]}<br/>"
    mail(:to => 'theredneckroundup@gmail.com', :subject => 'Advertising Request', :body => @body, :reply_to => params[:username])
  end
end
