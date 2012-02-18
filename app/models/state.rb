class State < ActiveRecord::Base
  belongs_to :user
  has_one :character, :dependent => :destroy
  has_many :commands, :dependent => :destroy

  # ゲームの初期化
  def init
    self.current = '1958-01-01' # ゲーム開始日
    self.character = Character.create( :state_id => :id )
    self.character.init
    self.save
  end

  # ターン内の各日にコマンドを適用し、その結果の文字列の配列を取得する。
  def getTurnCommandsResults(command)
    d = self.current
    day = d
    day = (day >> 1) - 1 # 月の最終日
    i = 0
    results = []
    max = day.day
    while i < max do
      r = d.to_s
      r += getDailyCommandResult(command)
      e = getEvent(d)
      if e
        r = r + " (" + e.name + ")"
      end
      results.push(r)
      i = i + 1
      d = d + 1
    end
    self.current = d
    self.save
    return results
  end

  # コマンドを１日毎に適用してその結果の文字列を取得する。
  def getDailyCommandResult(command)
    r = "："
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

  # 渡された日付のイベントを取得する。
  def getEvent(day)
    e = Event.where("s_date <= ? AND e_date >= ?", day, day).first
    r = rand(100) # 0～99
    if e && e.probability < r
      e = nil
    end
    return e
  end

  def isTimeOver
    l_day = Time.local(1959, 9, 30, 0, 0, 0) # ゲームの終わり
    t_day = Time.local(current.year, current.month, current.day, 0, 0, 0)
    return t_day.to_i > l_day.to_i
  end
end
