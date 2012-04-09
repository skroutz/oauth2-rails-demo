require 'test_helper'

class AuthorizationControllerTest < ActionController::TestCase
  test 'should post authorize and redirect to auth url' do
    post :authorize

    assert_response :redirect
    assert_match /#{SkroutzEasy::SITE}#{SkroutzEasy::URL[:authorize]}/, response.location
  end

  test 'should get callback and ask for address' do
    # Setup
    code = 'aCode'
    first_name = 'FirstName'
    address = 'Address'

    # Mocks
    oauth_client = mock('oauth_client')
    auth_code = mock('auth_code')
    token = mock('token')
    oauth_response = mock('oauth_response')

    # Given - Expectations
    oauth_client.expects(:auth_code).returns(auth_code)
    auth_code.expects(:get_token).with(code, has_key(:redirect_uri), all_of(has_entry(:mode => :query), has_entry(:param_name => :oauth_token))).returns(token)
    token.expects(:get).with(SkroutzEasy::URL[:address]).returns(oauth_response)
    oauth_response.expects(:parsed).returns({:first_name => first_name, :address => address})
    OAuth2::Client.expects(:new).returns(oauth_client)

    # When
    get :callback, {:code => code}

    # Then
    assert_response :success
    json = MultiJson.decode(response.body, :symbolize_keys => true)
    assert_equal first_name, json[:first_name]
    assert_equal address, json[:address]
  end

  test 'should get callback and handle auth error' do
    # Setup
    code = 'aCode'
    first_name = 'FirstName'
    address = 'Address'

    # Mocks
    oauth_client = mock('oauth_client')
    auth_code = mock('auth_code')
    oauth_response = mock('oauth_response', :error= => nil, :parsed => [])

    # Given - Expectations
    oauth_client.expects(:auth_code).returns(auth_code)
    auth_code.expects(:get_token).with(code, has_key(:redirect_uri), all_of(has_key(:mode), has_key(:param_name))).raises(OAuth2::Error.new(oauth_response))
    OAuth2::Client.expects(:new).returns(oauth_client)

    # When
    get :callback, {:code => code}

    # Then
    assert_response :success
    assert_equal 'no response', response.body
  end
end
