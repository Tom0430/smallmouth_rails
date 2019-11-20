class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
    end
    def edit
        @user = User.find(current_user.id)
    end

    def update
        user = User.find(params[:id])
        if user.update(user_params)
        redirect_to user_path(user.id)
        else
            redirect_to about_path
        end
    end
    def achieved_list
        @goals = current_user.goals.where(status: 1).order(id: "DESC")
    end
    def failed_list
        @goals = current_user.goals.where(status: 2).order(id: "DESC")
    end
    def trying_list
        @goals = current_user.goals.where(status: 0).order(id: "DESC")
    end


    private
    def user_params
        params.require(:user).permit(:name, :profile_text, :image)
    end
end
