class Goal < ApplicationRecord
    belongs_to :user
    has_many :progresses, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :rates, dependent: :destroy

    enum limit_time: {limit30s: 0, limit6h: 1, limit1d: 2, limit3d: 3, limit7d: 4 , limit5s: 5, limit1m: 6}
    enum status: {trying: 0, achieved: 1, failed: 2}
    # Goal.weekly = Goal.where( created_at: 1.weeks.ago.beginning_of_day..Time.zone.now.end_of_day )
    # Rateにgoalを内部結合したとき(joins(:goal))は、クラス自体はRateのままなので、このメソッドが使えない。ので、mergeメソッドでRateクラスにこのメソッドを移譲している。
    # => Rate.joins(:goal).merge(Goal.weekly)
    scope :weekly, -> { where( created_at: 1.weeks.ago.beginning_of_day..Time.zone.now.end_of_day ) }
    # enumの値を入力として、それに応じた現在の時刻 + limit_timeがdatetimeで返ってくるメソッド
    def remaining_time
        now = self.created_at
        case self.limit_time_before_type_cast
        when 0 then
            remaining_time = now + 30
        when 1 then
            remaining_time = now + 60 * 60 * 6
        when 2 then
            remaining_time = now + 60 * 60 * 24
        when 3 then
            remaining_time = now + 60 * 60 * 72
        when 4 then
            remaining_time = now + 60 * 60 * 168
        when 5 then
            remaining_time = now + 5
        when 6 then
            remaining_time = now + 60
        end
        return remaining_time
    end

    def rated_by?(current_user)
        rates.where(user_id: current_user.id).exists?
    end
end
