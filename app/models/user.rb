class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader
  validates_presence_of :name

  def admin?
    self.role == "admin"
  end

  def toggle_admin!
    self.admin = !self.admin
  end
end
