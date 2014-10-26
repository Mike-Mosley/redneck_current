class HollerFan < ActiveRecord::Base
   attr_accessible :user_id, :holler_id
  belongs_to :holler
  belongs_to :user
end
