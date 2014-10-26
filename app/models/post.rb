class Post < ActiveRecord::Base
  attr_accessible :post

  belongs_to :user, :foreign_key => :created_by
  has_many :likes, :as => :addressable
  after_save :email_alert

  def liked(user)
    logger.info self.likes.inspect
    if Like.where(:addressable_id => self.id, :addressable_type => 'Post').select{|l| l.user_id.to_i == user.to_i}.length > 0
      return true
    else
      return false
    end
  end

  def comments
    @comments = Post.where(:addressable_type => 'Comment', :addressable_id => self.id).order("created_at DESC").limit(2).all.reverse
  end

  def comment_length
    @comments = Post.where(:addressable_type => 'Comment', :addressable_id => self.id).all
    return @comments.length
  end

  def all_comments
    @comments = Post.where(:addressable_type => 'Comment', :addressable_id => self.id).all
  end

  def email_alert
    users = []
    if self.addressable_type == 'Comment'
      post = Post.find(self.addressable_id)
      users << post.created_by
      post.comments.each do |c|
        users << c.created_by
      end
      users.uniq!
      UserMailer.comment_update(users, self, post).deliver
    end
  end
end
