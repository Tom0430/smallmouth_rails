namespace :send_limit do
    desc "1分ごとに目標期限をチェックしてメールを送信"
    task :send_limit => :environment do
        goals = Goal.where(status: 0).joins(:user)
        goals.each do |goal|
            if  Time.now  - goal.created_at < 10000 && Time.now  - goal.created_at > 560
                @user = goal.user
                NotificationMailer.send_limit_to_user(@user).deliver
            end
        end
    end
end
