class UserController < ApplicationController
  layout 'application'

  def index
    if current_user.nil? == false
      redirect_to :controller => 'roundup'
    else
      @user = User.new
    end
  end

  def login
    @user = User.authenticate(params[:user][:username],params[:user][:password])
    if @user.nil? == false
      session[:current_user] =  @user
      if params[:user][:remember_me] == "1"
        cookies[:current_user] = {:value => session[:current_user], :expires => 2.weeks.from_now}
      end
      redirect_to :controller => 'roundup'
    else
      render 'login_page'
    end
  end

  def create
    @user = User.create(params[:user])
    if @user.save
      redirect_to :action => 'finish_registration', :id => @user.id
        @friend = Friend.new
        @friend.user_id = @user.id
        @friend.friend_id = 68
        @reverse_friend = Friend.new
        @reverse_friend.friend_id = @user.id
        @reverse_friend.user_id = 68
        @friend.save
        @reverse_friend.save
    else
      render 'index'
    end
  end

  def finish_registration
    @user = User.find(params[:id])
  end

  def complete_registration
    @user = User.find(params[:id])
    @user.sex_id = params[:user][:sex_id]
    @user.relationship_status_id = params[:user][:relationship_status_id]
    @user.date_of_birth = params[:user][:date_of_birth]
    if @user.save(:validate => false)
      @user.send_confirmation
      redirect_to :action => 'share_redneck_roundup', :id => @user.id
    else
      render 'finish_registration'
    end
  end

  def share_redneck_roundup
    @user = User.find(params[:id])
  end

  def validate_email
    @user = User.find(params[:id])
    @validated = @user.validate_email(params[:hash])
    if @validate == true
      @user.update_attribute(:activated => true)
    end
  end

  def send_password_reset_request
    User.send_password_reset(params[:user][:username])
  end

  def admin_send_password_reset_request
    @user = User.find(params[:id])
    User.send_password_reset(@user.username)
  end

  def password_reset
    @user = User.find(params[:id])
    if @user.reset_password_token != params[:verifier]
      render 'reset_error'
    end
  end

  def set_new_password
    @user = User.find(params[:id])
    if params[:user][:password].to_s == params[:user][:pwd_confirmation].to_s
      @user.update_password(params[:user][:password])
      render 'login_page'
    else
      @user.errors
      render 'password_reset'
    end
  end

  def log_off
    session[:current_user] = nil
    cookies[:current_user] = nil
    redirect_to :action => 'login_page'
  end

  def edit_settings
    @user = current_user
  end

  def save_settings
    @user = current_user
    if @user.update_attributes(params[:user])
      render 'settings'
    else
      render 'edit_settings'
    end
  end

  def set_profile_picture
    @image = Image.new
  end

  def set_holler_picture
    @image = Image.new
    @holler =  Holler.find(params[:id])
  end
  def set_background_picture
    @image = Image.new
  end

  def set_holler_background
    @image = Image.new
    @holler =  Holler.find(params[:id])
  end

  def save_profile_picture
    @image = Image.new
    @images = Image.where(:user_id => current_user.id, :image_type_id => 0).all
    @images.each do |i|
      i.update_attribute(:image_type_id, 2)
    end
    if current_user.profile_album.nil? == true
      @album = Album.new
      @album.user_id = current_user.id
      @album.name = "Profile Pictures"
    else
      @album = current_user.profile_album
    end
    @picture = params[:image][:name]
    @image.album_id = @album.id
    @image.name = @picture.original_filename
    @image.image_type_id = 0
    @image.user_id = current_user.id
    if @image.save
      store_image(@picture, @image)
      @image.set_urls
      render 'profile_settings'
    else
      render 'set_profile_picture'
    end


  end

  def save_holler_picture
    @hollers = Holler.where(:user_id => current_user.id).all
    @image = Image.new
    @holler = Holler.find(params[:id])
    @images = Image.where(:user_id => @holler.id, :image_type_id => 3).all
    @images.each do |i|
      i.update_attribute(:image_type_id, 5)
    end
    @picture = params[:image][:name]
    @image.name = @picture.original_filename
    @image.image_type_id = 3
    @image.user_id = current_user.id
    if @image.save
      store_image(@picture, @image)
      @image.set_urls

      render 'holler_settings'
    else
      render 'set_holler_picture'
    end


  end

   def save_holler_background
     @hollers = Holler.where(:user_id => current_user.id).all
    @image = Image.new
    @holler = Holler.find(params[:id])
    @images = Image.where(:user_id => @holler.id, :image_type_id => 4).all
    @images.each do |i|
      i.update_attribute(:image_type_id, 5)
    end
    @picture = params[:image][:name]
    @image.name = @picture.original_filename
    @image.image_type_id = 4
    @image.user_id = @holler.id
    if @image.save
      store_image(@picture, @image)
      @image.set_urls
      render 'holler_settings'
    else
      render 'set_holler_picture'
    end


   end

  def fix_holler_pics
    @hollers = Holler.all
    @hollers.each do |h|
      @image =  Image.where(:user_id => h.user_id, :image_type_id => 3).first
      @image.update_attribute(:user_id, h.id)
    end
  end

  def log_in_as
    @user = User.find(params[:id])
    if @user.nil? == false
      session[:current_user] =  @user
      redirect_to :controller => 'roundup'
    else
      render 'login_page'
    end
  end

  def save_background_picture
    @image = Image.new
    if current_user.background_image.nil? == false
      current_user.background_image.update_attributes(:image_type_id => 2)
    end
    if current_user.background_album.nil? == true
      @album = Album.new
      @album.user_id = current_user.id
      @album.name = "Background Pictures"
    else
      @album = @user.profile_album
    end
    @picture = params[:image][:name]
    @image.album_id = @album.id
    @image.name = @picture.original_filename
    @image.image_type_id = 1
    @image.user_id = current_user.id
    if @image.save
      store_image(@picture, @image)
      @image.set_urls
      render 'profile_settings'
    else
      render 'set_profile_picture'
    end
  end

  def background
    @user = User.find(params[:id])
    if @user.background_image.nil?
      @image = Net::HTTP.get(URI("http://theredneckroundup.com/assets/camo1.png"))
      send_data @image, :filename => 'camo1.png'
    else
      @image = Net::HTTP.get(URI(@user.background_image.image_url))
      send_data @image, :filename => @user.background_image.name
    end
  end
  def holler_background
    @holler = Holler.find(params[:id])
    if @holler.background_image.nil?
      @image = Net::HTTP.get(URI("http://theredneckroundup.com/assets/camo1.png"))
      send_data @image, :filename => 'camo1.png'
    else
      @image = Net::HTTP.get(URI(@holler.background_image.image_url))
      send_data @image, :filename => @holler.background_image.name
    end
  end

  def holler_settings
    @hollers = Holler.where(:user_id => current_user.id).all
  end

  def edit_holler_form
    @holler = Holler.find(params[:id])
  end

  def create_holler_form
    @holler = Holler.new()
  end

  def save_holler
    @holler = Holler.new(params[:holler])
    @holler.user_id = current_user.id
    @holler.save
    render 'holler_settings'
  end

  def delete_hollers
    @hollers = Holler.all
    @hollers.each do |h|
      h.destroy
    end
  end
end
