
class Yauth::FailureApp
  def call(env)
    [401, 
      { "Content-Type" => "text/plain", 
        "WWW-Authenticate" => %(Basic realm="Yauth secured area") }, 
      ["#{env['warden'].message}\n"]]
  end
end
