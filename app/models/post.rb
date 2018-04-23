class Post < ApplicationRecord
  # mount_uploader :image, PhotoUploader
  validates_presence_of :content

  belongs_to :user, counter_cache: true
  belongs_to :category


  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  def is_liked?(user)
   self.liked_users.include?(user)
  end
end
