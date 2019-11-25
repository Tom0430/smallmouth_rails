class CommentsController < ApplicationController
    def create
        goal = Goal.find(params[:goal_id])
        comment = current_user.comments.new(comment_params)
        comment.goal_id = goal.id
        comment.save
        redirect_to user_goal_path(goal.user.id, goal.id)
    end
    private
    def comment_params
      params.require(:comment).permit(:user_id,:goal_id,:body)
    end
end
