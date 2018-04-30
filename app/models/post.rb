class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader
  validates_presence_of :content

  belongs_to :user, counter_cache: true
  belongs_to :category


  has_many :post_categories, dependent: :restrict_with_error
  has_many :categories, through: :post_categories

  has_many :comments, dependent: :destroy

  has_many :collects, dependent: :destroy
  has_many :collected_users, through: :collects, source: :user

  scope :open_public, -> { where(public: true) }

    def self.readable_posts(user)
      Post.where(authority: "friend", user: user.all_friends).or( where(authority: "all")).or(where(authority: "myself", user: user)).or(where( user: user))
    end

    def check_authority_for?(user)
     Post.readable_posts(user).open_public.include?(self)
    end

    def is_collected?(user)
     self.collected_users.include?(user)
    end

    is_impressionable

end
