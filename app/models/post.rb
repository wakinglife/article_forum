class Post < ApplicationRecord
  # mount_uploader :image, ImageUploader
  validates_presence_of :content

  belongs_to :user, counter_cache: true




end
