namespace :send_limit do
    desc "1分ごとに目標期限をチェックしてメールを送信"
    task :send_limit => :environment do
        goals = Goal.where(status: 0).joins(:user)
        goals.each do |goal|
            if  goal.user.accept_recieving_email == true
                if goal.limit_time == "limit1w" && Time.now  - goal.created_at < 345660 && Time.now  - goal.created_at > 345600 || goal.limit_time == "limit3d" && Time.now  - goal.created_at < 172860 && Time.now  - goal.created_at > 172800
                    @user = goal.user
                    @goal = goal
                    NotificationMailer.send_limit_to_user(@user, @goal).deliver
                end
            end
        end
    end
end
