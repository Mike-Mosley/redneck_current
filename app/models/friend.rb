class Friend < ActiveRecord::Base
  # attr_accessible :title, :body
  def requester
    User.find(self.friend_id)
  end
end
