class GameController < ApplicationController
  before_filter :authenticate_user!

  def start
    @current_chara = Character.where(:user_id => current_user.id).first;
    @current_state = State.where(:user_id => current_user.id).first;
    @has_data = @current_chara && @current_state
  end

  def new
    Character.delete_all("user_id = " + current_user.id.to_s)
    State.delete_all("user_id = " + current_user.id.to_s)
    @current_chara = Character.new(
                       :user_id => current_user.id,
                       :name => 'バーナビー・マーベリック',
                       :birthday => '1953-10-31'
                     );
    @current_chara.save;
    @current_state = State.new(
                       :user_id => current_user.id,
                       :current => '1958-01-01'
                     );
    @current_state.save;
  end

  def play
    @current_chara = Character.where(:user_id => current_user.id).first;
    @current_state = State.where(:user_id => current_user.id).first;

    day = @current_state.current
    l_day = Time.local(1962, 9, 30, 0, 0, 0) # ゲームの終わり
    t_day = Time.local(day.year, day.month, day.day, 0, 0, 0)
    if (t_day.to_i < l_day.to_i)
      procCommand(@current_state)
    else
      procTimeOver(@current_state)
    end

    @age = @current_chara.age(@current_state.current)
  end

  def bye
  end

  def test

  end

private

  def getResults(current_state)
    d = current_state.current
    day = d
    day = (day >> 1) - 1 # 最終日
    i = 0
    results = []
    max = day.day
    while i < max do
      r = d.to_s
      e = procEvent(d)
      if e
        r = r + " (" + e.name + ")"
      end
      results.push(r)
      i = i + 1
      d = d + 1
    end
    current_state.current = d
    current_state.save
    return results
  end

  def procCommand(current_state)
    command = Command.where("id = ? ", params[:command_id]).first.name
    if (params[:commit] && !(command.blank?))
      @message = ((current_state.current >> 1) - 1).to_s
      @message += "まで"
      @message += command
      @message += "をおこないます"
      @results = getResults(@current_state)
    else
      @message = "コマンドを入力してください"
      @results = []
    end
  end

  def procTimeOver(current_state)
    @message = "育成期間は終了しました。"
    @results = []
  end

  def procEvent(day)
    e = Event.where("s_date <= ? AND e_date >= ?", day, day).first
    r = rand(100) # 0～99
    if e && e.probability < r
      e = nil
    end
    return e
  end
end
