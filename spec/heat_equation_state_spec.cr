require "minitest/autorun"
require "./state_interface_test"
require "heat_equation_state"
require "./behaves_like_a"

describe HeatEquationState do
  behaves_like_a StateInterfaceTest
  let(:state) { HeatEquationState.new([1.0,2.0,3.0]) }

  it "returns values in the same order" do
    state.values.must_equal({1.0,2.0,3.0})
  end
end
