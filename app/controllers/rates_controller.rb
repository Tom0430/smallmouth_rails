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


    private
    def rate_params
      params.require(:rate).permit(:user_id, :goal_id, :quantity)
    end
end
