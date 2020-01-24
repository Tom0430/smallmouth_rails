class NotificationMailer < ActionMailer::Base
    default from: "hogehoge@example.com"

    def send_confirm_to_user(user)
      @user = user
      mail(
        subject: "会員登録が完了しました。", #メールのタイトル
        to: @user.email #宛先
      ) do |format|
        format.text
      end
    end

    def send_limit_to_user(user)
      @user = user
      mail(
        subject: "目標の期限が迫っております。", #メールのタイトル
        to: @user.email #宛先
      ) do |format|
        format.text
      end
    end
  end
