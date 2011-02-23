
class Yauth::UserManager
  include Enumerable

  def initialize
    @list = []
  end

  def add(user)
    remove(user.username)
    @list << user
  end

  def remove(name)
    user = @list.find { |u| u.username == name }
    @list.delete(user)
  end

  def each(&block)
    @list.each(&block)
  end

  def save(path)
    open(path, "w") do |io|
      io << @list.to_yaml
    end
  end

  def self.load(path)
    manager = self.new
    return manager unless File.exists? path
    open(path) do |io|
      YAML.load(io).each { |h| manager.add(Yauth::User.new(h)) }
    end
    manager
  end
end
