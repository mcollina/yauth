require 'yaml'
require 'digest/sha1'
require 'thor'
require 'warden'

module Yauth
  class << self
    attr_accessor :location
  end
  Yauth.location = "config/users.yml"
end

require File.join(File.dirname(__FILE__), "yauth", "user")
require File.join(File.dirname(__FILE__), "yauth", "user_manager")
require File.join(File.dirname(__FILE__), "yauth", "cli")
require File.join(File.dirname(__FILE__), "yauth", "strategy")
require File.join(File.dirname(__FILE__), "yauth", "failure_app")
