class NotificationMailer < ActionMailer::Base
    default from: "qwdvgy03@gmail.com"

    def send_confirm_to_user(user)
      @user = user
      mail(
        subject: "会員登録が完了しました。", #メールのタイトル
        to: @user.email #宛先
      ) do |format|
        format.text
      end
    end

    def send_limit_to_user(user, goal)
      @user = user
      @goal = goal
      mail(
        subject: "チャレンジの期限が残り3日となりました。", #メールのタイトル
        to: @user.email #宛先
      ) do |format|
        format.text
      end
    end
  end
