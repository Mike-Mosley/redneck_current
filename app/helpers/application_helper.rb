module ApplicationHelper
  def generate_media
    if browser.ie? == false
     return browser.name.downcase
    else
      return "ie"
    end
  end
end
