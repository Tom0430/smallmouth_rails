require 'rails_helper'

RSpec.describe Goal, type: :model do
    context "when a goal is valid" do
        it "is valid with all data" do
            goal = build(:goal)
            expect(goal).to be_valid
        end
    end
    context "when a item is invalid" do
        it "is invalid without title" do
            goal = build(:goal, title: "   ")
            expect(goal).to_not be_valid
        end
        it "is invalid with too long title" do
            title = "a" * 51
            goal = build(:goal, title: title )
            expect(goal).to_not be_valid
        end
        it "is invalid without detail" do
            goal = build(:goal, detail: "   ")
            expect(goal).to_not be_valid
        end
        it "is invalid with too long detail" do
            detail = "a" * 501
            goal = build(:goal, detail: detail )
            expect(goal).to_not be_valid
        end
        it "is invalid without limit_time" do
            goal = build(:goal, limit_time: "   ")
            expect(goal).to_not be_valid
        end
    end
end