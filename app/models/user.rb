class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  validates_presence_of :name, length: { maximum: 20 }
  validates :name, uniqueness: true

  has_many :posts, dependent: :restrict_with_error
  

  def admin?
    self.role == "admin"
  end

  def toggle_admin!
    self.admin = !self.admin
  end
end
