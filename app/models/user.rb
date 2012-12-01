class User < ActiveRecord::Base
  attr_accessible :last_name, :username, :pwd_confirmation, :pwd, :first_name, :sex_id, :date_of_birth, :cb_name, :relationship_status_id, :activated
  validates :username, :presence => true, :uniqueness => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  attr_accessor :password_confirmation
  attr_accessor :pwd_confirmation

  has_many :images
  has_many :albums
  has_many :posts, :as => :created_by
  has_many :friends

  SEX_IDs = [
  ["Male",0],
  ["Female",1]
  ]

  RELATIONSHIP_IDs = [
  ["Single", 0],
  ["Married", 1]
  ]

  def remember_me

  end

  def pwd
    @pwd
  end

  def pwd=(pwd)
    @pwd = pwd
    create_new_salt
    self.password = User.encrypted_password(self.pwd, self.salt)
  end

  def self.authenticate (name, password)
    user = self.find_by_username(name)

    if user
      expected_password = encrypted_password(password, user.salt)
      user = nil if user.password != expected_password
    end

    user
  end

  def hashed_password
    string_to_hash = self.password + "294b482092198b" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "294b482092198b" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def send_confirmation
    UserMailer.email_address_confirmation(self).deliver
  end

  def registration_hash
    string_to_hash = self.id.to_s + self.salt.to_s + "redneck"
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def validate_email(hash)
    logger.info hash
    logger.info self.registration_hash
    if self.registration_hash == hash
      return true
    else
      return false
    end
  end

  def self.send_password_reset(username)
    user = self.find_by_username(username)
    token_string = self.id.to_s + "redneck" + Time.now.to_s
    user.update_attribute(:reset_password_token, Digest::SHA1.hexdigest(token_string))
    UserMailer.password_reset(user).deliver
  end

  def update_password(password)
    self.update_attribute(:password, User.encrypted_password(password, self.salt))
  end

  def profile_image
    @profile_image = Image.where(:user_id => self.id, :image_type_id => 0).first
  end

  def background_image
    @profile_image = Image.where(:user_id => self.id, :image_type_id => 1).first
  end

  def profile_album
    @profile_album = Album.where(:user_id => self.id, :name => "Profile Pictures").first
  end

  def background_album
    @profile_album = Album.where(:user_id => self.id, :name => "Background Pictures").first
  end

  def gather_posts
    @posts = []
    @posts << Post.where("created_by IN (#{self.friends.collect(&:friend_id).join(",")}) or created_by = #{self.id}").where(:addressable_type => 'Status').order("created_at DESC").limit(10).all
    @posts.flatten!
  end

  def random_friends
    self.friends.sort_by{rand}[0..8]
  end

  def pending_requests
    @pending_request = FriendRequest.find_all_by_request_to(self.id)
  end

  def all_images
    @images = Image.where("user_id IN (#{self.friends.collect(&:friend_id).join(",")}) or user_id = #{self.id}").limit(17).order("created_at DESC")
  end

  def more_images(id,direction)
    if direction == "right"
      @images = Image.where("user_id IN (#{self.friends.collect(&:friend_id).join(",")}) or user_id = #{self.id}").limit(17).order("created_at DESC").all.paginate(:page => id.to_i + 1)
    end
  end

  def mark_watched
    self.view_video = true
    self.update_attribute(:view_video, true)
  end

end
