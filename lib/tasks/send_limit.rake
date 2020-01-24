namespace :send_limit do
    desc "1分ごとに目標期限をチェックしてメールを送信"
  task :send_limit => :environment do
    goals = Goal.joins(:user)

     goals.each do |goal|
         @user = goal.user
         NotificationMailer.send_limit_to_user(@user).deliver
    end
  end
end
