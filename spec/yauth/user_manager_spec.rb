require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe UserManager do
  subject { UserManager.new }

  [:add, :remove, :each, :save].each do |m|
    it do
      should respond_to(m)
    end
  end

  def mock_user(name)
    user = mock "user #{name}"
    user.stub(:username).and_return(name)
    user
  end

  it "should add a user" do
    user = mock_user "user"
    subject.add user
    subject.to_a.should == [user]
  end

  it "should not add the same user twice" do
    user = mock_user "user"
    subject.add user
    subject.add user
    subject.to_a.should == [user]
  end

  it "should remove a user given its username" do
    user = mock_user "name"
    subject.add user
    subject.remove("name").should == user
    subject.to_a.should == []
  end

  it "should yield each added user" do 
    first = mock_user "first"
    second = mock_user "second"
    subject.should_receive(:each).and_yield(first, second)
    subject.add first 
    subject.add second 
    subject.each {}
  end

  it "should save all its user to the specified file" do
    first = User.new(:username => "first", :password => "123") 
    second = User.new(:username => "second", :password => "456") 
    subject.add(first)
    subject.add(second)

    path = "a/path/to.yml"
    io = StringIO.new
    subject.should_receive(:open).with(path, "w").and_yield(io)
    subject.save(path)
    io.string.should == <<-EOF
--- 
- user: 
    username: first
    password: "123"
- user: 
    username: second
    password: "456"
EOF
  end

  it "should find a user by its username" do
    first = User.new(:username => "first", :password => "123") 
    second = User.new(:username => "second", :password => "456") 
    subject.add(first)
    subject.add(second)

    subject.find_by_username("first").should == first
    subject.find_by_username("second").should == second
  end

  it "should authenticate a user by its username and password" do
    user = mock "user"
    subject.should_receive(:find_by_username).with("name").and_return(user)
    user.should_receive(:authenticate).with("password").and_return(true)

    subject.authenticate("name", "password").should == user
  end

  it "should not authenticate a user if the password doesn't match" do
    user = mock "user"
    subject.should_receive(:find_by_username).with("name").and_return(user)
    user.should_receive(:authenticate).with("password").and_return(false)

    subject.authenticate("name", "password").should be_false
  end

  it "should not authenticate if there is no match" do
    subject.should_receive(:find_by_username).with("name").and_return(nil)
    subject.authenticate("name", "password").should be_false
  end
end

describe UserManager, "as a class" do

  subject { UserManager }

  it "should mix in Enumerable" do
    subject.ancestors.should include(Enumerable)
  end

  it { should respond_to(:load) }

  describe "#load" do
    it "should load from a yaml file if that file exists" do 
      path = "a/path/to.yml"
      io = StringIO.new <<-EOF
- user:
    username: first
    password: 123456
- user:
    username: second
    password: 789012
      EOF
      File.stub(:exists?).with(path).and_return(true)
      UserManager.should_receive(:open).with(path).and_yield(io)
      manager = UserManager.load(path)

      ary = manager.to_a
      ary.size.should == 2

      ary[0].username.should == "first"
      ary[0].password.should == 123456
      ary[1].username.should == "second"
      ary[1].password.should == 789012
    end

    it "should create a new UserManager if the file doesn't exists" do 
      path = "a/path/to.yml"
      File.stub(:exists?).with(path).and_return(false)
      manager = UserManager.load(path)
      manager.to_a.should == []
    end
  end
end
