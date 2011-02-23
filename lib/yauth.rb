require 'yaml'
require 'digest/sha1'
require 'thor'

module Yauth
  autoload :User, File.join("yauth", "user")
  autoload :UserManager, File.join("yauth", "user_manager")
  autoload :CLI, File.join("yauth", "cli")
end
