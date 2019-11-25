class UsersController < ApplicationController
    before_action :set_user, except: :index

    def index
        users = User.all.includes([goals: :rates])
        @users = Kaminari.paginate_array(users).page(params[:page]).per(9)
    end

    def show
    end

    def edit
    end

    def update
        if user.update(user_params)
            redirect_to user_path(user.id)
        else
            redirect_to about_path
        end
    end

    def trying_list
        @goals = current_user.id == @user.id ? goals_list(0).order(id: "DESC") : goals_list(1).where(published: true).order(id: "DESC")
    end

    def achieved_list
        @goals = current_user.id == @user.id ? goals_list(1).order(id: "DESC") : goals_list(1).where(published: true).order(id: "DESC")
    end

    def failed_list
        @goals = current_user.id == @user.id ? goals_list(2).order(id: "DESC") : goals_list(1).where(published: true).order(id: "DESC")
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
