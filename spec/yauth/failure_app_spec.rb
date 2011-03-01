require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe FailureApp do

  subject { FailureApp.new }

  def mock_env(message="hello")
    warden = mock "warden"
    warden.stub!(:message).and_return(message)
    { 'warden' => warden }
  end

  it "should return 401" do
    subject.call(mock_env)[0].should == 401
  end

  it "should have Content-Type 'text/plain'" do
    subject.call(mock_env)[1]["Content-Type"].should == 'text/plain'
  end

  it "should have WWW-Authenticate set" do
    subject.call(mock_env)[1]["WWW-Authenticate"].should == %(Basic realm="Yauth secured area")
  end

  it "should have the body set as the warden message" do
    subject.call(mock_env("hello world"))[2][0].should =~ /hello world/
  end

  it { should respond_to(:realm) } 

  it { should respond_to(:realm=) }

  it "should have a default realm" do
    subject.realm.should == "Yauth secured area"
  end

  it "should have WWW-Authenticate with the realm configured" do
    subject.realm = "My Realm"
    subject.call(mock_env)[1]["WWW-Authenticate"].should == %(Basic realm="My Realm")
  end
end
