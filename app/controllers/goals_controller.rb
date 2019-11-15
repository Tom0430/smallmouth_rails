class GoalsController < ApplicationController
    def new
        @user = current_user
        @goal = Goal.new
    end

    def create
        goal = Goal.new(goal_params)
        goal.user_id = current_user.id
        if goal.save
            redirect_to user_goal_path(goal.user.id, goal.id)
        else
            render :new
        end
    end

    def index
        @goals = Goal.all.includes(:user)
    end

    def show
        @user = current_user
        @goal = Goal.find(params[:id])
        @comment = Comment.new
    end

    def achieved
        goal = Goal.find(params[:id])
        goal.update(status:1)
    end

    def failed
        goal = Goal.find(params[:id])
        goal.update(status: 2)
    end

    private
    def goal_params
        params.require(:goal).permit(:title, :detail, :limit_time, :status)
    end
end
