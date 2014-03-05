class ApplicationController < ActionController::Base
  protect_from_forgery
  include Onliner

  before_filter { |c| c.track_user current_user unless current_user.nil?}
end
