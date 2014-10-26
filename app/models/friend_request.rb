class FriendRequest < ActiveRecord::Base
  # attr_accessible :title, :body

  def requester
    begin
      return User.find(self.request_by)
    rescue
      self.destroy
    end

  end
end
