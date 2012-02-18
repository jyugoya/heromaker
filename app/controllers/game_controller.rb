class GameController < ApplicationController
  before_filter :authenticate_user!

  def start
    @current_state = State.where(:user_id => current_user.id).first;
    @current_chara = @current_state.character;
    @has_data = @current_chara && @current_state
  end

  def new
    # Character.delete_all("user_id = " + current_user.id.to_s)
    State.delete_all("user_id = " + current_user.id.to_s)
    @current_state = State.create(
                       :user_id => current_user.id,
                       :current => '1958-01-01'
                     );
    @current_chara = Character.create(
                       :state_id => @current_state.id,
                       :name => 'バーナビー・マーベリック',
                       :birthday => '1953-10-31'
                     );
  end

  def play
    @current_state = State.where(:user_id => current_user.id).first;
    @current_chara = @current_state.character;

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

  def getResults(current_state, command)
    d = current_state.current
    day = d
    day = (day >> 1) - 1 # 最終日
    i = 0
    results = []
    max = day.day
    while i < max do
      r = d.to_s
      r += getDailyCommandResult(current_state, command)
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

  def getDailyCommandResult(current_state, command)
    r = "：";
    command.effects.each do |e|
      c_chara = current_state.character
      p = c_chara.parameters.find_by_name(e.p_name)
      p.value += e.e_value
      if p.value < 0
        p.value = 0 # 0未満にはならない
      end
      p.save
      r += e.p_name
      if e.e_value > 0
        r += "+"
      end
      r += e.e_value.to_s + " "
    end
    return r;
  end

  def procCommand(current_state)
    if (params[:command_id])
      command = Command.where("id = ? ", params[:command_id]).first
      @message = ((current_state.current >> 1) - 1).to_s
      @message += "まで"
      @message += command.name
      @message += "をおこないます"
      @results = getResults(@current_state, command)
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
