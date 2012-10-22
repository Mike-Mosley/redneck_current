class User < ActiveRecord::Base
  attr_accessible :last_name, :username, :pwd_confirmation, :pwd, :first_name, :sex_id, :date_of_birth, :cb_name, :relationship_status_id
  validates :username, :presence => true, :uniqueness => true
  validates :pwd, :presence => true, :confirmation => true
  validates :pwd_confirmation, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  attr_accessor :password_confirmation

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
      user = nil if user.hashed_password != expected_password
    end

    user
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "294b482092198b" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def send_confirmation
    UserMailer.deliver_email_address_confirmation(self)
  end

  def generate_advertisements

  end
end
