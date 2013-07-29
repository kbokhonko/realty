class Comment < ActiveRecord::Base
  attr_accessible :poster_id, :text, :user_id

  belongs_to :poster
  belongs_to :user
end
