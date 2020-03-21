require 'rails_helper'

RSpec.describe Goal, type: :model do
    context "when a goal is valid" do
        it "is valid with all data" do
            # user = create(:user)
            goal = build(:goal)
            expect(goal).to be_valid
        end
    end
end