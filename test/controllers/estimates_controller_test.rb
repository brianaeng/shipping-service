require 'test_helper'

class EstimatesControllerTest < ActionController::TestCase

  setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
   end

   test "The #shipping_rate method returns JSON" do
   	get :shipping_rate, {service_id: "USPS", weight: 10, state: "WA", city: "Bainbridge Island", zip: "98110"}
    assert_match 'application/json', response.header['Content-Type']
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

  test "an unknown service_id will return no content" do
    get :shipping_rate, {service_id: "TEST", weight: 10, state: "WA", city: "Kirkland", zip: "98034"}

    assert_response 204
  end

  test "a request with no weight will return no content" do
    get :shipping_rate, {service_id: "TEST", weight: nil, state: "WA", city: "Kirkland", zip: "98034"}

    assert_response 204
  end

  test "a request with no state will return no content" do
    get :shipping_rate, {service_id: "TEST", weight: 10, state: nil, city: "Kirkland", zip: "98034"}

    assert_response 204
  end

  test "a request with no city will return no content" do
    get :shipping_rate, {service_id: "TEST", weight: 10, state: "WA", city: nil, zip: "98034"}

    assert_response 204
  end

  test "a request with no zip will return no content" do
    get :shipping_rate, {service_id: "TEST", weight: 10, state: "WA", city: "Kirkland", zip: nil}

    assert_response 204
  end
end
