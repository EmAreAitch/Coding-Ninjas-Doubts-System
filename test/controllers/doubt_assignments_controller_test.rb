require "test_helper"

class DoubtAssignmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get doubt_assignments_index_url
    assert_response :success
  end
end
