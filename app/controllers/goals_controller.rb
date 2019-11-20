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
        if params[:search].blank?
            @goals = Goal.all.includes(:user).order(id: "DESC")
        else
            title = Goal.where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            detail = Goal.where("detail LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            user = Goal.joins(:user).where("name LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            merged_search_result = ( title | detail )
            @goal = ( merged_search_resultsearch | user )
        end
    end

    def show
        @user = current_user
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
    def ranking
        @goal_id_and_quantities_arrays = Rate.group(:goal_id).sum(:quantity).sort{|(k1, v1), (k2, v2)| v2 <=> v1 }
        @user_id_and_quantities_arrays = Rate.joins(goal: :user).group("goals.user_id").sum(:quantity).sort{|(k1, v1), (k2, v2)| v2 <=> v1 }
        # @weekly_goal_id_and_quantities_arrays = Rate.joins(:goal).where(created_at: 1.weeks.ago.beginning_of_day..Time.zone.now.end_of_day).sum(:quantity).sort{|(k1, v1), (k2, v2)| v2 <=> v1 }
        # @weekly_user_rate_id_and_quantities_arrays = Rate.where(created_at: 1.weeks.ago.beginning_of_day..Time.zone.now.end_of_day).group(:user_id).sum(:quantity).sort{|(k1, v1), (k2, v2)| v2 <=> v1 }
    end

    private
    def goal_params
        params.require(:goal).permit(:title, :detail, :limit_time, :status)
    end
end
