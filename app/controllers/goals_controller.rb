class GoalsController < ApplicationController
    before_action :set_goal, except: [:index, :create, :new]

    def new
        @goal = Goal.new
    end

    def create
        goal = Goal.new(goal_params)
        goal.user_id = current_user.id
        if goal.save
            redirect_to user_goal_path(goal.user.id, goal.id)
        else
            @goal = goal
            render :new
        end
    end

    def update
        # 公開、非公開の切り替え
        @goal.update(published: params[:goal][:published])
        redirect_to user_goal_path(current_user.id, @goal.id)
    end

    def index
        # 検索したときには検索結果を、そうでない時は全チャレンジを一覧表示 一覧画面では公開されたチャレンジのみ表示する
        # gem Kaminariでpagenation
        if params[:search].present?
            title = Goal.where(published: true).where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            detail = Goal.where(published: true).where("detail LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            user = Goal.where(published: true).joins(:user).where("name LIKE ?", "%#{params[:search]}%").order(id: "DESC")
            result = ( title | detail )
            merged_search_result = ( result | user )
            @goals = Kaminari.paginate_array(merged_search_result).page(params[:page]).per(10)
        else
            goals = Goal.where(published: true).includes([:user, :rates]).order(id: "DESC")
            @goals = Kaminari.paginate_array(goals).page(params[:page]).per(9)
        end
    end

    def show
        @comment = Comment.new
        @progress = Progress.new
        # idを見つけてあるならupdate,ないならcreateする。評価は１人１回までで数は変更できるように
        if user_signed_in?
            @rate = Rate.find_or_initialize_by(user_id: current_user.id, goal_id: @goal.id)
        end
    end

    def achieved
        @goal.update(status:1)
    end

    def failed
        @goal.update(status: 2)
    end

    private
    def goal_params
        params.require(:goal).permit(:title, :detail, :limit_time, :status)
    end
    def set_goal
        @goal = Goal.find(params[:id])
    end
end
