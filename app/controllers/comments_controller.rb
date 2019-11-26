class CommentsController < ApplicationController
    def create
        goal = Goal.find(params[:goal_id])
        comment = Comment.new(comment_params)
        comment.goal_id = goal.id
        comment.user_id = current_user.id
        if
          comment.save
          redirect_to user_goal_path(comment.goal.user, comment.goal)
        else
          render 'goals/show'
        end
    end
    def destroy
      comment = Comment.find(params[:id])
      comment.delete
      redirect_to user_goal_path(comment.goal.user.id, comment.goal.id)
    end
    private
    def comment_params
      params.require(:comment).permit(:user_id,:goal_id,:body)
    end
end
