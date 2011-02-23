
class Yauth::CLI < Thor

  desc "add USERNAME PASSWORD", "Adds or updates a user"
  method_options :config => "config/users.yml"
  def add(username, password)
    puts "#{username}-#{password}"
    puts options[:config]
  end

  desc "rm USERNAME", "Remove a user"
  method_options :config => "config/users.yml"
  def rm(username)
    puts "#{username}"
    puts options[:config]
  end
end
