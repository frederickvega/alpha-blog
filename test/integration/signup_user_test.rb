require 'test_helper'

class SignupUserTest < ActionDispatch::IntegrationTest

  test "sign up as new user" do
    get signup_path
    assert_template "users/new"
    assert_difference "User.count", 1 do
      post_via_redirect users_path, user: {username: "fred", email: "fred@email.com", password: "password", admin: false}
    end
    assert_template "users/show"
    assert_match "fred", response.body
  end

  test "sign up as invalid user results in failure" do
    get signup_path
    assert_template "users/new"
    assert_no_difference "User.count", 1 do
      post_via_redirect users_path, user: {username: "fred", email: "fred", password: "password", admin: false}
    end
    assert_template "users/new"
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end
