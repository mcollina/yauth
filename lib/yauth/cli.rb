
class Yauth::CLI < Thor

  attr_reader :manager

  desc "add USERNAME PASSWORD", "Adds or updates a user"
  method_options :config => Yauth.location
  def add(username, password)
    init_manager
    user = Yauth::User.new
    user.username = username
    user.plain_password = password
    manager.add(user)
    save_manager
  end

  desc "rm USERNAME", "Remove a user"
  method_options :config => Yauth.location
  def rm(username)
    init_manager
    manager.remove(username)
    save_manager
  end

  private
  def init_manager
    @manager = Yauth::UserManager.load(options[:config])
  end

  def save_manager
    FileUtils.mkdir_p(File.dirname(options[:config]))
    @manager.save(options[:config])
  end
end
