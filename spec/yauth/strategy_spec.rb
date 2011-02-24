require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'rack'

describe Strategy do
  subject { Strategy.new({}) }

  it { subject.should respond_to(:authenticate!) }

  it "should loads a manager" do
    manager = mock "Manager"
    UserManager.should_receive(:load).with(Yauth.location).and_return(manager)
    subject #needed to initialize the subject
  end

  describe "with a loaded manager" do

    before(:each) do
      @manager = mock "Manager"
      UserManager.stub(:load).and_return(@manager)

      env = mock "Env"
      subject.should_receive(:env).and_return(env)
      @request = mock "Request"
      Rack::Auth::Basic::Request.should_receive(:new).with(env).and_return(@request)
    end

    it "should authenticate if valid credentials are passed" do
      @request.should_receive(:provided?).and_return(true)
      @request.should_receive(:basic?).and_return(true)
      credentials = [mock("credentials1"), mock("credentials2")]
      @request.should_receive(:credentials).and_return(credentials)

      user = mock "user"
      @manager.should_receive(:authenticate).with(*credentials).and_return(user)
      subject.should_receive(:success!).with(user)
      subject.authenticate!
    end

    it "should not authenticate if there are no credentials" do
      @request.should_receive(:provided?).and_return(false)

      subject.should_receive(:fail!).with("Could not log in")
      subject.should_not_receive(:success!)
      subject.authenticate!
    end
  end
end

describe Strategy, "as a class" do
  it "should install itself into Warden" do
    Warden::Strategies.should_receive(:add).with(:yauth_users, Strategy)
    Strategy.install!
  end 
end
