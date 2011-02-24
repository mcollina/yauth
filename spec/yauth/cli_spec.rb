require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'fileutils'

describe CLI do

  subject { CLI.new }

  before :each do
    FileUtils.stub!(:mkdir_p)
    @options = {}
    subject.stub!(:options).and_return(@options)
  end

  [:add, :rm].each do |m|
    it { should respond_to(m) }
  end

  it "should add a user to the manager with the specified config" do
    @options[:config] = "config/users.yml"
    manager = mock "Manager"
    UserManager.should_receive(:load).with("config/users.yml").and_return(manager)

    user = mock "User"
    User.should_receive(:new).and_return(user)
    user.should_receive(:username=).with("bar")
    user.should_receive(:plain_password=).with("foo")

    manager.should_receive(:add).with(user)

    FileUtils.should_receive(:mkdir_p).with("config")
    manager.should_receive(:save).with("config/users.yml")
    subject.add("bar", "foo")
  end

  it "should remove from the manager with the specified config" do
    @options[:config] = "config/users.yml"
    manager = mock "Manager"
    UserManager.should_receive(:load).with("config/users.yml").and_return(manager)

    manager.should_receive(:remove).with("bar")

    FileUtils.should_receive(:mkdir_p).with("config")
    manager.should_receive(:save).with("config/users.yml")
    subject.rm("bar")
  end
end
