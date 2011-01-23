require 'spec_helper'

describe "password_resets/show.html.erb" do
  before(:each) do
    @password_reset = assign(:password_reset, stub_model(PasswordReset,
      :token => "Token",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Token/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
