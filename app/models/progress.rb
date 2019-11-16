class Progress < ApplicationRecord
    belongs_to :goal
    mount_uploader :progress_image, ImageUploader
end
