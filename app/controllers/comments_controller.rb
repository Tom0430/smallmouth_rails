class CommentsController < ApplicationController
    def create
        goal = Goal.find(params[:goal_id])
        # binding.pry
        comment = current_user.comments.new(comment_params)
        comment.goal_id = goal.id
        comment.save
        redirect_to goal_path(goal)
    end
    private
    def comment_params
      params.require(:comment).permit(:user_id,:goal_id,:body)
    end
end
