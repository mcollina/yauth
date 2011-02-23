
class Yauth::User
  attr_accessor :username, :password
  attr_reader :plain_password

  def initialize(hash={})
    hash = hash[:user] if hash[:user]
    hash = hash["user"] if hash["user"]

    self.username = hash[:username] || hash["username"]
    self.password = hash[:password] || hash["password"]
  end

  def plain_password=(plain_password)
    self.password = Digest::SHA256.hexdigest(plain_password)
    @plain_password = plain_password
  end
  
  def to_hash
    { "user" => { "username" => username, "password" => password } }
  end

  def to_yaml(opts={})
    to_hash.to_yaml(opts)
  end
end
