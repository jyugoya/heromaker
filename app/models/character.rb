class Character < ActiveRecord::Base
  belongs_to :state
  has_many :parameters, :dependent => :destroy

  # キャラクターの初期化
  def init
    self.name = 'バーナビー・マーベリック'
    self.birthday = '1953-10-31'

    # パラメータ生成（今埋め込み）
    self.parameters.push( Parameter.create(
                         :character_id => 1, :name => '体力', :value => 10 ))
    self.parameters.push( Parameter.create(
                         :character_id => 1, :name => '知力', :value => 10 ))
    self.parameters.push( Parameter.create(
                         :character_id => 1, :name => '疲労', :value => 0 ))

    self.save
  end

  # 渡された日時における年齢を計算する
  def age(calcDay = state.c_date)
    (calcDay.strftime("%Y%m%d").to_i-birthday.strftime("%Y%m%d").to_i)/10000
  end

  # 渡されたEffectを当該パラメータに適用する
  def apply(effect)
    p = parameters.find_by_name(effect.p_name)
    p.value += effect.e_value
    if p.value < 0
      p.value = 0 # 0未満にはならない
    end
    p.save
  end
end
