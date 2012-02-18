class Character < ActiveRecord::Base
  belongs_to :state
  has_many :parameters

  def age(calcDay)
    (calcDay.strftime("%Y%m%d").to_i-birthday.strftime("%Y%m%d").to_i)/10000
  end
end
