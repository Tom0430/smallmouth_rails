class UsersController < ApplicationController
    def achieved_list
        @goals = current_user.goals.where(status: 1)
    end
    def failed_list
        @goals = current_user.goals.where(status: 2)
    end
    def trying_list
        @goals = current_user.goals.where(status: 0)
    end
end
