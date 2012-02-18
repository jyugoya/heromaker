class State < ActiveRecord::Base
  belongs_to :user
  has_one :character
  has_many :commands
end
