class Goal < ApplicationRecord
    belongs_to :user
    has_many :progresses, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :rates, dependent: :destroy

    enum limit_itme: {limit20s: 0, limit6h: 1, limit1d: 2, limit3d: 3, limit7d: 4}
end
