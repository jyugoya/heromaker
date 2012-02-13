class GameController < ApplicationController
  before_filter :authenticate_user!

  def start
  end

  def bye
  end

end
