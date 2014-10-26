class Video < ActiveRecord::Base
   attr_accessible :user_id, :embed_code

  belongs_to :user
  after_save :create_post

  def create_post
    @post = Post.where("addressable_type = 'Video' and addressable_id = #{self.id}").first
    if @post.nil? == true
      @post = Post.new()
      @post.like_count = 0
      @post.comment_count = 0
      @post.created_by = self.user_id
      @post.addressable_id = self.id
      @post.addressable_type = 'Video'
      @post.save
    end
  end
end
