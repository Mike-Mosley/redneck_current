class RoundupController < ApplicationController
  layout 'roundup', :except => [:radio]
  before_filter :check_login

  def index
    if current_user.nil? == true
      redirect_to :controller => 'user', :action => 'login_page'
    else
      @post = Post.new
      @posts = current_user.gather_posts
      @all = Post.all
      @friend_requests = current_user.pending_requests
    end
    logger.info "TEST"
  end

  def user_profile
    @user = User.find(params[:id])
    if current_user.nil? == true
      redirect_to :controller => 'user', :action => 'login_page'
    end
    @post = Post.new
    @posts = @user.user_posts
    @all = Post.all
    @friend_requests = @user.pending_requests
  end

  def holler_page
    @holler = Holler.find(params[:id])
    @post = Post.new
    @posts = @holler.holler_posts
    @holler_fan = HollerFan.where(:user_id => current_user.id, :holler_id => @holler.id).first
  end

  def become_a_fan
    @holler_fan = HollerFan.new(:holler_id => params[:id], :user_id => current_user.id)
    @holler_fan.save
    @holler = Holler.find(params[:id])
    @post = Post.new
    @posts = @holler.holler_posts
    render 'holler_page', :id => @holler.id

  end

  def share_holler_page
    @holler = Holler.find(params[:id])
    @holler_share = Post.new
    @holler_share.like_count = 0
    @holler_share.comment_count = 0
    @holler_share.created_by = current_user.id
    @holler_share.addressable_id = @holler.id
    @holler_share.addressable_type = 'HollerShare'
    @holler_share.save
    @post = Post.new
    @posts = current_user.gather_posts
    @all = Post.all
    @friend_requests = current_user.pending_requests
    render 'index'
  end

  def create
    @post = Post.new(params[:post])
    @post.like_count = 0
    @post.comment_count = 0
    @post.created_by = current_user.id
    @post.addressable_id = current_user.id
    @post.addressable_type = 'Status'
    @post.save
  end

  def wall_post
    @post = Post.new(params[:post])
    @post.like_count = 0
    @post.comment_count = 0
    @post.created_by = current_user.id
    @post.addressable_id = params[:user_id]
    @post.addressable_type = 'Wall'
    @post.save
  end

  def radio
    render :layout => false
  end

  def holler_wall_post
    @post = Post.new(params[:post])
    @post.like_count = 0
    @post.comment_count = 0
    @post.created_by = current_user.id
    @post.addressable_id = params[:user_id]
    @post.addressable_type = 'HollerFanPost'
    @post.save
  end

  def holler_user_wall_post
    @post = Post.new(params[:post])
    @post.like_count = 0
    @post.comment_count = 0
    @post.created_by = current_user.id
    @post.addressable_id = params[:user_id]
    @post.addressable_type = 'HollerPost'
    @post.save
  end

  def like_post
    @post = Post.find(params[:id])
    @like = Like.new
    @like.user_id = current_user.id
    @like.addressable_id=@post.id
    @like.addressable_type='Post'
    if @like.save
      @post.update_attribute(:like_count, @post.like_count + 1)
    end
  end

  def unlike_post
    @post = Post.find(params[:id])
    @like = @post.likes.select{|p| p.user_id == current_user.id}.first
    if @like.destroy
      @post.update_attribute(:like_count, @post.like_count - 1)
    end
  end

  def save_comment
    @post = Post.find(params[:id])
    @comment = Post.new(params[:comment])
    @comment.addressable_id = @post.id
    @comment.addressable_type = 'Comment'
    @comment.created_by = current_user.id
    @comment.like_count = 0
    @comment.comment_count = 0
    @comment.save
  end

  def show_add_event_form
    @holler = Holler.find(params[:id])
  end

  def save_event
    @holler = Holler.find(params[:id])
    @post = Post.new
    @posts = @holler.holler_posts
    @holler_fan = HollerFan.where(:user_id => current_user.id, :holler_id => @holler.id).first
    @event = Event.new()
    @event.event_name = params[:event][:event_name]
    @event.description = params[:event][:description]
    @event.event_date = Time.utc(params[:event]["event_date(1i)"],params[:event]["event_date(2i)"],params[:event]["event_date(3i)"],0,0,0)
    @event.holler_id = @holler.id
    @event.active = true
    logger.info @event.inspect
    @event.save
    render :action => 'holler_page', :id => @holler.id
  end

  def show_all_comments
    @post = Post.find(params[:id])
    @comments = @post.comments
    @all_comments = @post.all_comments
    @new_comments = @all_comments - @comments
    @new_comments.sort_by{|p| p.created_at}
  end

  def all_bud_buds
    @user = User.find(params[:id])
  end

  def all_profile_picture
    @user = User.find(params[:id])
  end

  def find_friends
    @suggested_users = User.where("cb_name LIKE '%#{params[:data]}%' or username LIKE '%#{params[:data]}%' or first_name LIKE '%#{params[:data]}%' or last_name LIKE '%#{params[:data]}%' ").all
    @suggested_users.delete(current_user)
    @current_requests = FriendRequest.find_all_by_request_by(current_user.id)
    @current_requests.each do |r|
      @suggested_users.delete_if{|f| f.id == r.request_to}
    end
    @current_friends = Friend.find_all_by_user_id(current_user.id)
    @current_friends.each do |f|
      @suggested_users.delete_if{|u| u.id == f.friend_id  }
    end
    @users = @suggested_users.sort_by{rand}[0..2]
  end
  def find_friends_full
    @suggested_users = User.where("cb_name LIKE '%#{params[:data]}%' or username LIKE '%#{params[:data]}%' or first_name LIKE '%#{params[:data]}%' or last_name LIKE '%#{params[:data]}%' ").all
    @suggested_users.delete(current_user)
    @current_requests = FriendRequest.find_all_by_request_by(current_user.id)
    @current_requests.each do |r|
      @suggested_users.delete_if{|f| f.id == r.request_to}
    end
    @users = @suggested_users
  end

  def send_friend_request
    @friend_request = FriendRequest.new
    @friend_request.request_by = current_user.id
    @friend_request.request_to= params[:id]
    @friend_request.active = true
    @friend_request.save
  end

  def send_profile_friend_request
    if check_friendship(current_user.id, params[:id]) == false
      @friend_request = FriendRequest.new
      @friend_request.request_by = current_user.id
      @friend_request.request_to= params[:id]
      @friend_request.active = true
      @friend_request.save
    end
  end

  def accept_friend_request
    @friend_request = FriendRequest.find(params[:id])
    @friend = Friend.new
    @friend.user_id = current_user.id
    @friend.friend_id = @friend_request.request_by
    @reverse_friend = Friend.new
    @reverse_friend.friend_id = current_user.id
    @reverse_friend.user_id = @friend_request.request_by
    @friend.save
    @reverse_friend.save
    @friend_request.destroy
  end

  def deny_friend_request
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy
  end

  def show_large_image
    @image = Image.find(params[:id])
  end
  def scroll_images
    @images, @page = current_user.more_images(params[:id],params[:direction])
  end

  def upload_image
    @image = Image.new
    @picture = params[:image][:name]
    @image.name = @picture.original_filename
    @image.image_type_id = 0
    @image.user_id = current_user.id
    if @image.save
      store_image(@picture, @image)
      @image.set_urls
      render :action => 'upload_pictures'
    end
  end

  def create_thumbnail
    @images = Image.find(76)
    @images.thumbnail_image
    @images.set_urls
    render :nothing => true
  end

  def set_urls
    @images = Image.all
    @images.each do |i|
      i.set_urls
    end
  end

  def add_all_to_all
    @users = User.all
    @all_users = User.all
    @all_users.each do |user|
      @users.delete_at(user.id)
      @users.each do |u|
        unless user.friends.select{|f| f.friend_id == u.id}.length > 0
          @friend = Friend.new
          @friend.user_id = u.id
          @friend.friend_id = user.id
          @reverse_friend = Friend.new
          @reverse_friend.friend_id = u.id
          @reverse_friend.user_id = user.id
          @friend.save
          @reverse_friend.save
        end
      end
    end
    render :nothing => true
  end

  def clear_duplicated_friends
    @friends = Friend.all
    @friends.each do |friend|
      @matches = @friends.select{|f| f.friend_id == friend.friend_id && f.user_id == friend.user_id}
      if @matches.length > 1
        @replacement_friend = Friend.new
        @replacement_friend.friend_id = friend.friend_id
        @replacement_friend.user_id = friend.user_id
        @matches.each do |m|
          m.destroy
          logger.info m.inspect
        end
        @replacement_friend.save
        logger.info @replacement_friend.inspect
      end
      @friends.delete_if{|f| f.friend_id == friend.friend_id && f.user_id == friend.user_id}
    end
    render :nothing => true
  end

  def terms

  end

  def feedback
    SupportMailer.send_feedback(current_user, params[:feedback][:description]).deliver
  end

  def scroll_left
    @next_image = current_user.next_image(params[:end])
  end

  def scroll_right
    @next_image = current_user.previous_image(params[:start])
    logger.info @next_image.inspect
  end

  def check_friendship(user, friend)
    @friend = Friend.find_by_user_id_and_friend_id(user,friend)
    @friend_request = FriendRequest.find_by_request_by_and_request_to(user,friend)
    if @friend.nil? == false && @friend_request.nil? == false
      return flase
    else
      return true
    end
  end

  def save_video
    @video = Video.new
    if params[:video][:embed_code].include?("v=") == true
      string = params[:video][:embed_code].split("v=")
      if string[1].include?("&") == true
        @video.embed_code = string[1].split("&")[0]
      else
        @video.embed_code = string[1]
      end

    elsif params[:video][:embed_code].include?("http://youtu.be/") == true
      string = params[:video][:embed_code].split("be/")
      if string[1].include?("?") == true
        @video.embed_code = string[1].split("?")[0]
      else
        @video.embed_code = string[1]
      end
    elsif params[:video][:embed_code].include?("<iframe") == true
      string = params[:video][:embed_code].split("/embed/")
      @video.embed_code = string[1].split("\"")[0]
    end
    @video.user_id = current_user.id
    @video.save
    redirect_to :action => 'index'
  end

private

  def check_login
    if current_user.nil?
      redirect_to :controller => 'user', :action => 'login_page'
    end
  end
end
