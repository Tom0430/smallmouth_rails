class Rate < ApplicationRecord
    belongs_to :goal
    belongs_to :user
end
