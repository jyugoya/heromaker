class AdminController < ApplicationController
  # before_filter :authenticate_user!
  before_filter :is_admin?

  def index
  end

  def user_list
    @users = User.all(:order => "id")
  end

  def chara_list
    @characters = Character.all(:order => "id")  
  end

  def state_list
    @states = State.all(:order => "id")  
  end

private

  def is_admin?
    unless (current_user && current_user.is_admin)
      redirect_to :root
    end
  end
end
