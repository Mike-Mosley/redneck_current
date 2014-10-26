require 'aws/s3'
class ApplicationController < ActionController::Base
  protect_from_forgery

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

  def store_image(file, image)
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAJ7EPYC7QYOWW6WZA',
      :secret_access_key => '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'
      )
    AWS::S3::S3Object.store("#{image.id.to_s}_#{file.original_filename}", file.read, 'redneck_images')
    image.thumbnail_image
    image.set_urls
  end

end
