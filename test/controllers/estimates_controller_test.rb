require 'test_helper'

class EstimatesControllerTest < ActionController::TestCase

  setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
   end

  test "a log of Estimates should be an array including relevant attributes" do
    get :requests_log
    body = JSON.parse(response.body)
    assert_instance_of Array, body

    attributes = ["costs", "created_at", "id", "name", "updated_at"]
    assert_equal attributes, body.map(&:keys).flatten.uniq.sort
  end

  test "a UPS estimate can be requested successfully" do
    get :shipping_rate, {service_id: "UPS", weight: 10, state: "WA", city: "Kirkland", zip: "98034"}

    assert_response 200
  end

  test "a USPS estimate can be requested successfully" do
    get :shipping_rate, {service_id: "USPS", weight: 10, state: "WA", city: "Kirkland", zip: "98034"}

    assert_response 200
  end

end
