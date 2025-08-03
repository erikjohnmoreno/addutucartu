require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get carts_url
    assert_response :success
  end

  test "should post add_item" do
    post carts_add_item_url
    assert_response :success
  end

  test "should delete remove_item" do
    delete carts_remove_item_url
    assert_response :success
  end
end
