require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get characters" do
    get :characters
    assert_response :success
  end

end
