class GoalsController < ApplicationController
    def new
        @goal = Goal.new
    end

    def create
        goal = Goal.new(goal_params)
        goal.user_id = current_user.id
        if goal.save
            redirect_to goal_path(goal.id)
        else
            render :new
        end
    end

    def index
        @goals = Goal.all
    end

    def show
        @goal = Goal.find(params[:id])
        @comment = Comment.new
    end

    def achieved
        goal = Goal.find(params[:goal_id])
        goal.update(status:1)
        @goals = current_user.goals.where(status: 1)
    end
    def failed
        goal = Goal.find(params[:goal_id])
        goal.update(status: 2)
        @goals = current_user.goals.where(status: 2)
    end

    private
    def goal_params
        params.require(:goal).permit(:title, :detail, :limit_time, :status)
    end
end
