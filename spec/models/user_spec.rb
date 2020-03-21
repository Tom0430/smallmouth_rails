require 'rails_helper'

RSpec.describe User, type: :model do
    context "when a user is valid" do
        it "is valid with all data" do
            user = build(:user)
            expect(user).to be_valid
        end
    end
    context "when a user is invalid" do
        it "is invalid with blank email" do
            # emailの上書きをしてエラーを起こす
            user = build(:user, email: "   ")
            # to_notにもできる
            expect(user).to_not be_valid
        end
        it "is invalid with blank password" do
            password = "    "
            user = build(:user, password: password, password_confirmation: password)
            expect(user).to_not be_valid
        end
        it "is invalid with too short password" do
            user = build(:user, password: "aaaaa", password_confirmation: "aaaaa")
            expect(user).to_not be_valid
        end
        it "is invalid with too long first_name" do
            name = "a" * 21
            user = build(:user, name: name )
            expect(user).to_not be_valid
        end
    end

end
