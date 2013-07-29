class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :nickname, :provider, :url, :username
  # attr_accessible :title, :body

  has_many :posters, dependent: :destroy
  has_many :comments, dependent: :destroy

  def self.find_for_facebook_oauth access_token
    if user = User.where(url: access_token.info.urls.Facebook).first
      user
    else
      if user = User.where(email: access_token.info.email).first
        user.update_attributes(provider: access_token.provider, url: access_token.info.urls.Facebook, username: access_token.extra.raw_info.name)
        user
      else
        User.create!(provider: access_token.provider, url: access_token.info.urls.Facebook, username: access_token.extra.raw_info.name, nickname: access_token.extra.raw_info.username, email: access_token.extra.raw_info.email, password: Devise.friendly_token[0,20])
      end
    end
  end

  def self.find_for_twitter_oauth auth
    user = User.where(provider: auth.provider, username: auth.uid).first
    if user
      return user
    else
      registered_user = User.where(email: auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else
        user = User.create(nickname: auth.info.name,
          provider: auth.provider,
          username: auth.info.name,
          email: auth.uid + "@twitter.com",
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end


  def self.find_for_vk_oauth auth
    user = User.where(provider: auth[:info].provider, nickname: auth[:extra][:raw_info].screen_name).first
    if user
      return user
    else
      registered_user = User.where(url: auth[:info].urls[:Vkontakte]).first
      if registered_user
        return registered_user
      else
        user = User.create!(nickname: auth[:extra][:raw_info].screen_name,
          email: auth[:extra][:raw_info].screen_name + "@vk.com",
          provider: auth[:info].provider,
          username: "#{auth[:extra][:raw_info].first_name} #{auth[:extra][:raw_info].last_name}",
          url: auth[:info].urls[:Vkontakte],
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end
end
