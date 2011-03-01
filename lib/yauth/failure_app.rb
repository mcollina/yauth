
class Yauth::FailureApp
  attr_accessor :realm

  def initialize(realm="Yauth secured area")
    self.realm = realm
  end

  def call(env)
    [401, 
      { "Content-Type" => "text/plain", 
        "WWW-Authenticate" => %(Basic realm="#{realm}") }, 
      ["#{env['warden'].message}\n"]]
  end
end
