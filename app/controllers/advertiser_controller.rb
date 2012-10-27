class AdvertiserController < ApplicationController
respond_to :html, :xml, :json
  def show_request_form
    respond_to do |format|
      format.js
    end
  end

  def hide_request_form
    respond_to do |format|
      format.js
    end
  end

  def send_ad_request
    AdvertiserMailer.deliver_ad_request(params[:ad_request])
    respond_to do |format|
      format.js
    end
  end

end
