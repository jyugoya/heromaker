class State < ActiveRecord::Base
  belongs_to :user
  has_one :character, :dependent => :destroy

  # コマンド実行結果の格納
  has_many :results, :dependent => :destroy

  # has_many :commands, :dependent => :destroy


  # ゲームの初期化
  def init
    self.c_date = '1958-01-01' # ゲーム開始日
    self.turn_end = (self.c_date >> 1) - 1 # ゲーム開始月の最終日
    self.character = Character.create( :state_id => :id )
    self.character.init
    self.save
  end

  def isTurnEnd
    c_day = self.c_date
    t_day = self.turn_end
    ct = Time.local(c_day.year, c_day.month, c_day.day, 0, 0, 0)
    tt = Time.local(t_day.year, t_day.month, t_day.day, 0, 0, 0)
    return t_day < c_day
  end

  # ターン内の各日にコマンドを適用し、その結果の文字列をresultsに格納する。
  def procTurnCommandsResults(command, controller)
    unless self.c_command_id
      self.c_command_id = command.id
      self.results.destroy_all
    end
    
    while (! isTurnEnd()) do
      r = getDailyCommandResult(command)
      e = getEvent

      self.c_date = self.c_date + 1

      if e
        r = r + " (" + e.name + ")"
        self.results.push(Result.new(:state_id => self.id, :r_string => r))
        self.c_event_id = e.id
        self.save
        controller.redirect_to :event
        return
      else
        self.results.push(Result.new(:state_id => self.id, :r_string => r))
      end
    end

    # 次のターンの準備
    c_first_day = Date.new(self.c_date.year, self.c_date.month, 1)
    self.turn_end = (c_first_day >> 1) - 1 # その月の最終日
    self.c_command_id = nil
    self.save
  end

  # コマンドを１日毎に適用してその結果の文字列を取得する。
  def getDailyCommandResult(command)
    r = self.c_date.to_s + "(" + self.turn_end.to_s + ")："
    command.effects.each do |e|
      self.character.apply(e)
      r += e.p_name
      if e.e_value > 0
        r += "+"
      end
      r += e.e_value.to_s + " "
    end
    return r;
  end

  # 現時点の日付のイベントを取得する。
  def getEvent
    e = Event.where("s_date <= ? AND e_date >= ?", self.c_date, self.c_date).first
    r = rand(100) # 0～99
    if e && e.probability < r
      e = nil
    end
    return e
  end

  # ゲーム期間が終了しているか判定する。
  def isTimeOver
    l_day = Time.local(1959, 9, 30, 0, 0, 0) # ゲームの終わり
    t_day = Time.local(c_date.year, c_date.month, c_date.day, 0, 0, 0)
    return t_day.to_i > l_day.to_i
  end
end
