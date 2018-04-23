class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  validates_presence_of :name, :email
  
  has_many :posts, dependent: :restrict_with_error

  has_many :comments, dependent: :restrict_with_error


  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post


  def admin?
    self.role == "admin"
  end

  def toggle_admin!
    self.admin = !self.admin
  end


end
