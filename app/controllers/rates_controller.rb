class RatesController < ApplicationController
    def create
        rate = Rate.new(rate_params)
        if rate.save
            render :json => rate
        end
      end


      def rate_params
        params.require(:rate).permit(:user_id, :goal_id, :quqntity)
      end
end
