class Poster < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :user
  has_many :comments, dependent: :destroy
end
