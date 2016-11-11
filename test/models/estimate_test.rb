require 'test_helper'

class EstimateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Estimate without a name is invalid" do
    assert_not estimates(:no_name).valid?
  end

  test "Estimate without a cost is invalid" do
    assert_not estimates(:no_cost).valid?
  end

  test "Estimate with a cost and name is valid" do
    assert estimates(:name_and_cost).valid?
  end
end
