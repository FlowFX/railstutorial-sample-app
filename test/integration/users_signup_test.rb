require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
