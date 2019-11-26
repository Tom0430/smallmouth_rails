class Progress < ApplicationRecord
    belongs_to :goal
    mount_uploader :progress_image, ImageUploader
    validates :body, presence: true, length: { maximum: 500 }
end
