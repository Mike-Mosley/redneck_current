module ApplicationHelper
  def generate_media
    if browser.ie? == true
     return "ie"
    elsif browser.chrome? == true
      return "chrome"
    elsif browser.firefox? == true
      return "firstfox"
    else
      return "chrome"
    end
  end
  def current_user
    if session[:current_user].nil? == false
      return session[:current_user]
    elsif cookies[:current_user].nil? == false
      session[:current_user] == cookies[:current_user]
      return session[:current_user]
    else
      return nil
    end
  end
end
