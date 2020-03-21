FactoryBot.define do
# to_aメソッドを使うと配列になって返ってくる
# [0,1,2,3,4]をシャッフルして一番目の数字をlimit_time_numberに入れている
    limit_time_number = (0..4).to_a.shuffle[0]

    case limit_time_number
    when 0
        limit_time = "limit1m"
    when 1
        limit_time = "limit8h"
    when 2
        limit_time = "limit1d"
    when 3
        limit_time = "limit3d"
    when 4
        limit_time = "limit1w"
    end
# return limit_time と記述するとエラーが起きる
# rubyはreturnいらない、処理を止めたいならbreak

    factory :goal do
        user_id { 1 }
        title { "チャレンジ" }
        detail { "チャレンジ詳細" }
        limit_time { limit_time }
        published { true }
        association :user
    end
end