class GoalsController < ApplicationController
    def new
        @goal = Goal.new
    end

    def create
        goal = Goal.new(goal_params)
        # binding.pry
        goal.user_id = current_user.id
        if goal.save
            redirect_to goal_path(goal.id)
        else
            render :new
        end
    end

    def index
        @goals = Goal.all
        # @goals = Goal.all
    end

    def show
        @goal = Goal.find(params[:id])
    end


    private
    def goal_params
        params.require(:goal).permit(:title, :detail, :limit_time)
    end
end
