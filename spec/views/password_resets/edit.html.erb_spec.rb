require 'spec_helper'

describe "password_resets/edit.html.erb" do
  before(:each) do
    @password_reset = assign(:password_reset, stub_model(PasswordReset,
      :token => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit password_reset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => password_reset_path(@password_reset), :method => "post" do
      assert_select "input#password_reset_token", :name => "password_reset[token]"
      assert_select "input#password_reset_user_id", :name => "password_reset[user_id]"
    end
  end
end
