require 'yaml'
require 'digest/sha1'
require 'thor'

module Yauth
  autoload :User, File.join(File.dirname(__FILE__), "yauth", "user")
  autoload :UserManager, File.join(File.dirname(__FILE__), "yauth", "user_manager")
  autoload :CLI, File.join(File.dirname(__FILE__), "yauth", "cli")
end
