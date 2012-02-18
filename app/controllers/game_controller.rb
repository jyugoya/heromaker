class GameController < ApplicationController
  before_filter :authenticate_user!

  def start
    @current_state = current_user.state
    @current_chara = @current_state.character
    @has_data = @current_state != nil
    @is_timeover = @current_state.isTimeOver()
  end

  def new
    current_user.state.destroy()
    @current_state = State.create( :user_id => current_user.id );
    @current_state.init
    @current_chara = @current_state.character
    current_user.state = @current_state
    current_user.save
  end

  def play
    @current_state = State.where(:user_id => current_user.id).first;
    @current_chara = @current_state.character;

    if (params[:command_id])
      if (@current_state.isTimeOver())
        @message = "育成期間は終了しました。"
        @results = []
        redirect_to :root
      else
        command = Command.find(params[:command_id])
        @message = ((@current_state.current >> 1) - 1).to_s
        @message += "まで"
        @message += command.name
        @message += "をおこないます"
        @results = @current_state.getTurnCommandsResults(command)
      end
    else
      @message = "コマンドを入力してください"
      @results = []
    end

    @age = @current_chara.age(@current_state.current)
  end

  def bye
  end

  def test

  end

private

# refactoring done!

end
