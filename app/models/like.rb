class Like < ActiveRecord::Base
  # attr_accessible :title, :body
  after_save :email_alert

  def email_alert
    UserMailer.like_update(self).deliver
  end

end