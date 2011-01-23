require 'spec_helper'

describe "password_resets/index.html.erb" do
  before(:each) do
    assign(:password_resets, [
      stub_model(PasswordReset,
        :token => "Token",
        :user_id => 1
      ),
      stub_model(PasswordReset,
        :token => "Token",
        :user_id => 1
      )
    ])
  end

  it "renders a list of password_resets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
