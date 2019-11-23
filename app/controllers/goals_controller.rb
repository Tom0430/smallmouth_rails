class GoalsController < ApplicationController
    def new
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
        # 検索したときには検索結果を、そうでない時は一覧表示
        if params[:search].present?
            title = Goal.where(published: true).where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            detail = Goal.where(published: true).where("detail LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            user = Goal.where(published: true).joins(:user).where("name LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            merged_result = ( title | detail )
            @goals = ( merged_result | user )
        else
            @goals = Goal.where(published: true).includes([:user, :rates]).order(id: "DESC")
        end
    end

    def show
        @goal = Goal.find(params[:id])
        @comment = Comment.new
        @progress = Progress.new
        @rate = Rate.find_or_initialize_by(user_id: current_user.id, goal_id: @goal.id)
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
