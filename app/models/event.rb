class Event < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :holler
end
