class Category < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  
  has_many :post_categories, dependent: :destroy
  has_many :classed_posts, through: :post_categories, source: :post

end
