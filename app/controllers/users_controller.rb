class UsersController < ApplicationController
  def online
  	@users = online_users    
  end
end