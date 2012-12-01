class FriendRequest < ActiveRecord::Base
  # attr_accessible :title, :body

  def requester
    User.find(self.request_by)
  end
end
