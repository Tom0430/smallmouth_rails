class Progress < ApplicationRecord
    belongs_to :goal
    mount_uploader :progress_image, ImageUploader
    mount_uploader :progress_video, VideoUploader
end
