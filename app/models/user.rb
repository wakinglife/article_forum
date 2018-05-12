class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  validates_presence_of :name, :email

  before_create :generate_authentication_token

  has_many :posts, dependent: :destroy

  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: :post

  has_many :collects, dependent: :destroy
  has_many :collected_posts, through: :collects, source: :post

  has_many :friendships, -> {where status: true}, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, -> {where status: true}, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :unconfirm_friendships, -> {where status: false}, class_name: "Friendship", dependent: :destroy
  has_many :unconfirm_friends, through: :unconfirm_friendships, source: :friend
  has_many :request_friendships, -> {where status: false}, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :request_friends, through: :request_friendships, source: :user

  def admin?
    self.role == "admin"
  end

  def all_friends
    friends = self.friends + self.inverse_friends
    return friends.uniq
  end

  def friend?(user)
    self.friends.include?(user) || self.inverse_friends.include?(user)
  end

  def unconfirm_friend?(user)
    self.unconfirm_friends.include?(user)
  end

  def request_friend?(user)
    self.request_friends.include?(user)
  end

  def generate_authentication_token
    self.authentication_token = Devise.friendly_token
  end

end
