class Image < ActiveRecord::Base
  attr_accessible :name, :image_type_id, :user_id, :album_id

  belongs_to :user

  IMAGE_TYPES = [
    ['Profile', 0],
    ['Background', 1],
    ['Album', 2]
  ]

  def image_url
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAJ7EPYC7QYOWW6WZA',
      :secret_access_key => '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'
      )
    s3File =  AWS::S3::S3Object.find "#{self.id}_#{self.name}", "redneck_images"
    return s3File.url(:expires_in => 60*60*24*30)
  end
end
