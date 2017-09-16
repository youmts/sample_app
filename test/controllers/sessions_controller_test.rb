require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "login_pathが取得できること" do
    get login_path
    assert_response :success
  end

end
