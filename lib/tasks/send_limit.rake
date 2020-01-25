namespace :send_limit do
    desc "1分ごとに目標期限をチェックしてメールを送信"
    task :send_limit => :environment do
        goals = Goal.where(status: 0).where(limit_time: limit1w).joins(:user)
        goals.each do |goal|
            if  Time.now  - goal.created_at < 345660 && Time.now  - goal.created_at > 345600
                @user = goal.user
                NotificationMailer.send_limit_to_user(@user).deliver
            end
        end
    end
end
