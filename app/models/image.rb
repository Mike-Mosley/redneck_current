class Image < ActiveRecord::Base
  attr_accessible :name, :image_type_id, :user_id, :album_id

  belongs_to :user
  after_save :create_post

  IMAGE_TYPES = [
    ['Profile', 0],
    ['Background', 1],
    ['Album', 2],
    ['Holler Profile', 3],
    ['Holler Background', 4],
    ['Holler Album', 5],

  ]

  def image_url
    begin
      AWS::S3::Base.establish_connection!(
        :access_key_id     => 'AKIAJ7EPYC7QYOWW6WZA',
        :secret_access_key => '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'
        )
      s3File =  AWS::S3::S3Object.find "#{self.id}_#{self.name}", "redneck_images"
      return s3File.url(:expires_in => 60*60*24*360)
    rescue
      return "http://theredneckroundup.com/no-picture.jpg"
    end
  end

  def thumbnail_image
    require 'mini_magick'
    image = MiniMagick::Image.open(self.image_url)
    image.resize "60x60"
    image.format "jpg"
    image.write "public/#{self.name}"
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAJ7EPYC7QYOWW6WZA',
      :secret_access_key => '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'
      )
    logger.info "#{Rails.root}/public/#{self.name}"
    AWS::S3::S3Object.store("#{self.id}_#{self.name}", open("#{Rails.root}/public/#{self.name}", "rb").read , 'redneck_thumbs')
  end

  def thumbnail_url_fetch
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAJ7EPYC7QYOWW6WZA',
      :secret_access_key => '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'
      )
    s3File =  AWS::S3::S3Object.find "#{self.id}_#{self.name}", "redneck_thumbs"
    return s3File.url(:expires_in => 60*60*24*360)
  end

  def set_urls
    self.update_attribute(:url, self.image_url)
    self.update_attribute(:thumbnail_url, self.thumbnail_url_fetch)
  end

  def create_post
    @post = Post.where("addressable_type = 'Image' and addressable_id = #{self.id}").first
    if @post.nil? == true
      @post = Post.new()
      @post.like_count = 0
      @post.comment_count = 0
      @post.created_by = self.user_id
      @post.addressable_id = self.id
      @post.addressable_type = 'Image'
      @post.save
    end
  end
end
