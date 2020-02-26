class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  has_many :goals, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy
  mount_uploader :image, ImageUploader
  validates :name,
    presence: true,
    length: { minimum: 2, maximum: 20 }
  validates :profile_text,
    length: { maximum: 500}

end
