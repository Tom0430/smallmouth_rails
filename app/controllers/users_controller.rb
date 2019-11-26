class UsersController < ApplicationController
    before_action :set_user, except: [:index,:update]

    def index
        users = User.all.includes([goals: :rates])
        @users = Kaminari.paginate_array(users).page(params[:page]).per(9)
    end

    def show
    end

    def edit
        if current_user == @user
        else
            redirect_to goals_path
        end
    end

    def update
        user = User.find(params[:id])
        if user.update(user_params)
            flash[:notice] = "情報を更新しました。"
            redirect_to user_path(user.id)
        else
            @user = user
            render :edit
        end
    end

    def trying_list
        # 自身の投稿は非公開でもリストに表示できるように設定 achieved,failed_listも同様
        @goals = user_signed_in? && current_user.id == @user.id ? goals_list(0).order(id: "DESC") : goals_list(0).where(published: true).order(id: "DESC")
    end

    def achieved_list
        @goals = user_signed_in? && current_user.id == @user.id ? goals_list(1).order(id: "DESC") : goals_list(1).where(published: true).order(id: "DESC")
    end

    def failed_list
        @goals = user_signed_in? && current_user.id == @user.id ? goals_list(2).order(id: "DESC") : goals_list(2).where(published: true).order(id: "DESC")
    end

    private
    def user_params
        params.require(:user).permit(:name, :profile_text, :image)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def goals_list(status)
        @user.goals.where(status: status)
    end
end
