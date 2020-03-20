require 'rails_helper'

RSpec.describe User, type: :model do
    context "when a user is valid" do
        it "is valid with all data" do
            user = build(:user)
            expect(user).to be_valid
        end
    end
end
