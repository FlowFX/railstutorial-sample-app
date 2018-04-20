require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:florian)
  end

  test 'micropost interface' do
    # Log in with an activated user
    log_in_as(@user)

    # Get '/'
    get root_path

    # There is pagination
    assert_select 'div.pagination'

    # There is a file upload field
    assert_select 'input[type=file]'

    # Invalid submission doesn't add a micropost
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: ''}}
    end
    # But it shows an error message
    assert_select 'div#error_explanation'

    # Valid submission including image upload
    content = 'This micropost really ties the room together'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    # adds a new micropost
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: {content: content,
                                                 picture: picture}}
    end
    # that has a picture
    assert Micropost.first.picture?
    # and we get redirected to the home page
    assert_redirected_to root_url
    follow_redirect!
    # where the new micropost is displayed
    assert_match content, response.body

    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end
