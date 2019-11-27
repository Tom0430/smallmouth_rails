class ProgressesController < ApplicationController
    def create
      @goal = Goal.find(params[:goal_id])
      progress = @goal.progresses.new(progress_params)
      progress.goal_id = @goal.id
      if progress.save
        redirect_to user_goal_path(goal.user.id, goal.id)
      else
        @progress_error_catcher = progress
        @progress = progress
        @comment = Comment.new
        @rate = Rate.find_or_initialize_by(user_id: current_user.id, goal_id: @goal.id)
        render 'goals/show'
      end
    end
    def destroy
      progress = Progress.find(params[:id])
      progress.delete
      redirect_to user_goal_path(progress.goal.user.id, progress.goal.id)
    end
    private
    def progress_params
      params.require(:progress).permit(:user_id,:goal_id,:body, :progress_image)
    end
end
