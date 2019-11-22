class ProgressesController < ApplicationController
    def create
        goal = Goal.find(params[:goal_id])
        progress = goal.progresses.new(progress_params)
        progress.goal_id = goal.id
        progress.save
        redirect_to user_goal_path(goal.user.id, goal.id)
    end
    private
    def progress_params
      params.require(:progress).permit(:user_id,:goal_id,:body, :progress_image)
    end
end
