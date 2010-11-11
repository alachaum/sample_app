require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    @attr = {:name => "Test User", :email => "test.user@example.com"}
  end

  it "should create the user given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    user_no_name = User.new(@attr.merge(:name => ""))
    user_no_name.should_not be_valid
  end

  it "should require an email" do
    user_no_email = User.new(@attr.merge(:email => ""))
    user_no_email.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    user_long_name = User.new(@attr.merge(:name => long_name))
    user_long_name.should_not be_valid
  end

  it "should accept valid user addresses" do
    addresses = %w[foo.bar@example.com foobar@truc.com.org CAPITAL@bla.truc]
    addresses.each do |address|
      user_valid_email = User.new(@attr.merge(:email => address))
      user_valid_email.should be_valid
    end
  end

  it "should reject invalid user addresses" do
    addresses = %w[foobar.org @truc foo footruc@.bar]
    addresses.each do |address|
      user_invalid_email = User.new(@attr.merge(:email => address))
      user_invalid_email.should_not be_valid
    end
  end

end
