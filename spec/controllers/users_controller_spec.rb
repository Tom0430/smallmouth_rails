require 'rails_helper'


RSpec.describe ::UsersController, type: :controller do
    before do
        user = create(:user)
        user_login user
    end

    describe "GET #show" do
        it "returns http success" do
            :destroy
            expect(response).to have_http_status(:success)
        end
    end


    describe "GET #" do
        it "returns http success" do
          :index
          expect(response).to have_http_status(:success)
        end
    end
    describe "GET #edit" do
        it "returns http success" do
          :edit
          expect(response).to have_http_status(:success)
        end
    end
end
