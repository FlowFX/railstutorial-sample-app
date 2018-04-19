require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    # Reset (global) deliveries array.
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get signup_path
    assert_select 'form[action="/signup"]'

    assert_no_difference 'User.count' do
      post signup_path, params: {user: {name: '',
                                       email: 'user@invalid',
                                       password: 'foo',
                                       password_confirmation: 'bar'}}
    end
    # response renders signup form again
    assert_template 'users/new'
    # error message are shown
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {user: {name: 'Example User',
                                        email: 'user@example.com',
                                        password: 'password0815',
                                        password_confirmation: 'password0815'}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    # assigns lets us access instance variables in the corresponding action. For example,
    # the Users controller's `create` action defines an @user variable, so we can access
    # it in the test using `assigns(:user)`.
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    follow_redirect!
    assert_not flash.empty?
    assert_template 'users/show'
    assert is_logged_in?
  end
end
