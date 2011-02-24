require 'rubygems'
require 'sinatra'
require File.join(File.dirname(__FILE__), "..", "..", "lib", "yauth")

configure do
  enable :sessions #needed by warden
end

Yauth::Strategy.install!

use Warden::Manager do |manager|
  manager.default_strategies :yauth_users
  manager.failure_app = Yauth::FailureApp.new
end

get '/' do
  # the configured user is "admin:admin"
  request.env['warden'].authenticate!
  "hello world\n"
end
