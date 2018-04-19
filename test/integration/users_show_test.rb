require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:florian)
    @other_user = users(:archer)
  end

  test 'Users are shown on the show page' do
    # GIVEN a logged-in user
    log_in_as(@user)

    # WHEN opening another user's profile page
    get user_path(@other_user)

    # THEN it's there.
    assert_template 'users/show'
  end

  test 'non-activated users are not shown, ever' do
    # GIVEN a non-activated user
    @other_user.toggle!(:activated)
    assert_not @other_user.activated?

    # WHEN opening that user's profile page
    log_in_as(@user)
    get user_path(@other_user)

    # THEN we get redirected to the home page.
    assert_redirected_to root_url
  end
end
