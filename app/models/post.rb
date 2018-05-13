class Post < ApplicationRecord
  # mount_uploader :image, PhotoUploader
  validates_presence_of :content, :title, :authority
  is_impressionable #:counter_cache => true, :column_name => :viewed_count

  belongs_to :user, counter_cache: true

  has_many :categories_posts
  has_many :categories, through: :categories_posts

  has_many :comments, dependent: :destroy

  has_many :collects, dependent: :destroy
  has_many :collected_users, through: :collects, source: :user

  # scope :open_public, -> { where(public: true) }


    def is_collected?(user)
     self.collected_users.include?(user)
    end



end
