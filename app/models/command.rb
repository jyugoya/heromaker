class Command < ActiveRecord::Base
  belongs_to :state
  has_many :effects
end
