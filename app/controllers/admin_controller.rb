class AdminController < ApplicationController

  def chara_list
    @characters = Character.all(:order => "name")  
  end

  def state_list
    @states = State.all(:order => "current")  
  end

end
