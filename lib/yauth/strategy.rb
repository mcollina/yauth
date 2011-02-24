
class Yauth::Strategy < Warden::Strategies::Base

  attr_reader :manager

  def initialize(*args)
    super(*args)
    @manager = Yauth::UserManager.load(Yauth.location)
  end

  def authenticate!
    auth = Rack::Auth::Basic::Request.new(env)
    credentials = auth.provided? && auth.basic? && auth.credentials 
    if not credentials or not user = manager.authenticate(*credentials)
      fail!("Could not log in") 
    else
      success!(user)
    end
  end

  def self.install!
    Warden::Strategies.add(:yauth_users, self)
  end
end
