class Holler < ActiveRecord::Base
  attr_accessible :title, :category_name, :post_settings, :user_id
  belongs_to :user
  has_many :holler_fans
  has_many :events, :conditions => "active = 1"

  POSTSETTINGs = [
    ['Allow All Users to Post', 0],
    ['Only Your Posts Allowed On Page', 1]
  ]

  def holler_posts
    @posts = []
    @posts << Post.where("addressable_id = #{self.id}").where(:addressable_type => 'HollerPost').order("created_at DESC").limit(10).all
    @posts << Post.where("addressable_id = #{self.id}").where(:addressable_type => 'HollerWallPost').order("created_at DESC").limit(10).all
    @posts.flatten!
    @posts.sort_by(&:created_at).reverse
  end

  def profile_picture
    @image = Image.where(:user_id => self.id, :image_type_id => 3).first
    return @image.nil? ? 'redneck_roundup_logo.png' : @image.url
  end

  def thumbnail_picture
    @image = Image.where(:user_id => self.id, :image_type_id => 3).first
    return @image.nil? ? 'redneck_roundup_logo.png' : @image.thumbnail_url
  end

  def random_friends
    self.holler_fans.all.sort_by{rand}[0..7]
  end

  def background_image
    @profile_image = Image.where("user_id = ? and image_type_id = ?", self.id, 4).first
    logger.info @profile_image.inspect
    return @profile_image
  end
end
