require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:user1)
    @report = reports(:one)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report" do
    assert_difference('Report.count') do
      post :create, report: { location: @report.location, report_type: @report.report_type}
    end

    assert_redirected_to report_path(assigns(:report))
  end

  test "should show report" do
    get :show, id: @report, :format => :json
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @report
    assert_response :success
  end

  test "should update report" do
    put :update, id: @report, report: { location: @report.location, report_type: @report.report_type }
    assert_redirected_to report_path(assigns(:report))
  end
end
