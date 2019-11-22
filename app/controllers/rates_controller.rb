class RatesController < ApplicationController
    def create
        goal = Goal.find(params[:goal_id])
        rate = goal.rates.new(rate_params)
        rate.save
        redirect_to user_goal_path(goal.user.id, goal.id)
    end

    def update
        goal = Goal.find(params[:goal_id])
        rate = Rate.find_by(user_id: current_user.id, goal_id: goal.id)
        rate.update(rate_params)
        redirect_to user_goal_path(goal.user.id, goal.id)
    end

    def ranking
        # ユーザーランキング 獲得評価数の高い順に表示
        user_id_and_quantities_arrays = Rate.joins(goal: :user).group("goals.user_id").sum(:quantity).sort{|(k1, v1), (k2, v2)| v2 <=> v1 }
        @users_rank = []
        user_id_and_quantities_arrays.first(10).each_with_index do |user_id_and_quantities_array, i|
            user_id = user_id_and_quantities_array[0]
            hash = {
                user_id: user_id,
                u_quantity: user_id_and_quantities_array[1],
                user_name: User.find(user_id).name,
                rank: i + 1
            }
            @users_rank.push(hash)
        end
        # 週間ユーザーランキング
        weekly_user_id_and_quantities_arrays = Rate.joins(goal: :user).group("goals.user_id").merge(Goal.weekly).sum(:quantity).sort{|(k1, v1), (k2, v2)| v2 <=> v1}
        @weekly_users_rank = []
        weekly_user_id_and_quantities_arrays.first(10).each_with_index do |user_id_and_quantities_array, i|
            user_id = user_id_and_quantities_array[0]
            hash = {
                user_id: user_id,
                u_quantity: user_id_and_quantities_array[1],
                user_name: User.find(user_id).name,
                rank: i + 1
            }
            @weekly_users_rank.push(hash)
        end

        # チャレンジランキング　評価の高いチャレンジを上から順位表示
        goal_id_and_quantities_arrays = Rate.group(:goal_id).sum(:quantity).sort{|(k1, v1), (k2, v2)| v2 <=> v1 }
        @goals_rank = []
        goal_id_and_quantities_arrays.first(10).each_with_index do |goal_id_and_quantities_array, i|
            goal_id = goal_id_and_quantities_array[0]
            goal_data = Goal.find(goal_id.to_i)
            hash = {
                goal_id: goal_id,
                quantity: goal_id_and_quantities_array[1],
                goal_setting_date: goal_data.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                rank: i + 1,
                limit_time: goal_data.limit_time_i18n,
                goal_user_id: goal_data.user,
                goal_data: goal_data
            }
            @goals_rank.push(hash)
        end
        #週間チャレンジランキング
        weekly_goal_id_and_quantities_arrays = Rate.joins(:goal).merge(Goal.weekly).group(:goal_id).sum(:quantity).sort{|(k1, v1), (k2, v2)| v2 <=> v1}
        @weekly_goals_rank = []
        weekly_goal_id_and_quantities_arrays.first(10).each_with_index do |goal_id_and_quantities_array, i|
            goal_id = goal_id_and_quantities_array[0]
            goal_data = Goal.find(goal_id.to_i)
            hash = {
                goal_id: goal_id,
                quantity: goal_id_and_quantities_array[1],
                goal_setting_date: goal_data.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                rank: i + 1,
                limit_time: goal_data.limit_time_i18n,
                goal_user_id: goal_data.user,
                goal_data: goal_data
            }
            @weekly_goals_rank.push(hash)
        end

    end


    private
    def rate_params
        params.require(:rate).permit(:user_id, :goal_id, :quantity)
    end
end
