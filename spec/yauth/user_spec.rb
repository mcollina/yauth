require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe User do
  subject { User.new }

  [:username, :password, :plain_password].each do |attr|
    it "should have an #{attr} accessor" do
      should respond_to(attr)
      should respond_to(attr.to_s + "=")
    end
  end

  it "should set the real password based on the plain password" do
    password = "hello world"
    cyphertext = mock "CypherText"
    BCrypt::Password.should_receive(:create).and_return(cyphertext)
    subject.plain_password = password
    subject.password.should == cyphertext
  end

  it "should memorize the plain password until the end of the session" do
    password = "hello world"
    subject.plain_password = password
    subject.plain_password.should == password
  end

  it "should be transformed to an hash" do
    subject.username = "XYZ"
    subject.password = "ABC"
    subject.to_hash.should == { "user" => { "username" => "XYZ", "password" => "ABC" } }
  end

  it "should yaml nicely" do
    subject.username = "XYZ"
    subject.password = "ABC"
    subject.to_yaml.should ==<<-EOF
--- 
user: 
  username: XYZ
  password: ABC
EOF
  end

  it { should respond_to(:authenticate) }

  it "should authenticate with the right password" do
    subject.username = "XYZ"
    subject.plain_password = "ABC"
    subject.authenticate("ABC").should be_true
  end

  it "should not authenticate with the wrong password" do
    subject.username = "XYZ"
    subject.plain_password = "ABC"
    subject.authenticate("XYZ").should be_false
  end

  it "should not authenticate with the empty password" do
    subject.username = "XYZ"
    subject.plain_password = "ABC"
    subject.authenticate("").should be_false
  end

  it "should not authenticate with the nil password" do
    subject.username = "XYZ"
    subject.plain_password = "ABC"
    subject.authenticate(nil).should be_false
  end

  describe "as a class" do

    it "should build a user from a prefixed hash with strings" do
      u = User.new({ "user" => { "username" => "XYZ", "password" => "ABC" } })
      u.username.should == "XYZ"
      u.password.should == "ABC"
    end

    it "should build a user from an prefixed hash with symbols" do
      u = User.new({ :"user" => { :"username" => "XYZ", :"password" => "ABC" } })
      u.username.should == "XYZ"
      u.password.should == "ABC"
    end

    it "should build a user from a hash with strings" do
      u = User.new({ "username" => "XYZ", "password" => "ABC" })
      u.username.should == "XYZ"
      u.password.should == "ABC"
    end

    it "should build a user from an hash with symbols" do
      u = User.new({ :"username" => "XYZ", :"password" => "ABC" })
      u.username.should == "XYZ"
      u.password.should == "ABC"
    end
  end
end
