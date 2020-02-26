class UsersController < ApplicationController
    before_action :set_user, except: [:index, :change_default_published, :change_accept_email]

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
        if @user.update(user_params)
            flash[:notice] = "情報を更新しました。"
            redirect_to user_path(user.id)
        else
            render :edit
        end
    end

    def destroy
        @user.delete
        redirect_to users_path
    end

    def trying_list
        # 自身の投稿は非公開でもリストに表示できるように設定 achieved,failed_listも同様
       @goals = goals_list(0)
    end

    def achieved_list
        @goals = goals_list(1)
    end

    def failed_list
        @goals = goals_list(2)
    end

    def change_default_published
        user = User.find(params[:user_id])
        user.update(default_published: params[:user][:default_published])
        redirect_to user_path(user.id)
    end

    def change_accept_email
        user = User.find(params[:user_id])
        user.update(accept_recieving_email: params[:user][:accept_recieving_email])
        redirect_to user_path(user.id)
    end

    private
    def user_params
        params.require(:user).permit(:name, :profile_text, :image, :default_published, :accept_recieving_email)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def goals_list(status)
        @user.goals.where(status: status)
    end
end
