require File.join(File.dirname(__FILE__), "spec_helper")

describe Yauth do
  subject { Yauth }

  it { should respond_to(:location) }
  it { should respond_to(:location=) }

  it "should store the default yml location" do
    subject.location.should == "config/users.yml"    
  end

  it "should be possible to overwrite the default yml location" do
    subject.location = "users.yml"
    subject.location.should == "users.yml"
  end
end
