require "minitest/autorun"
require "./behaves_like_a"
require "heat_equation_diff_eq"
require "expression"
require "generic_point"

class TestDifferentiatorMap
  def derivative(of, with_respect_to, degree = 1, point = 0)
    if(of == :u && with_respect_to == :t)
      [Expression.new value_id: 0, constant: 2.0]
    else
      [Expression.new value_id: 1, constant: 3.0]
    end
  end
end

describe DiffEq do
  it "can return the expected diff eq" do
    diff_eq = HeatEquationDiffEq.new differentiators: TestDifferentiatorMap.new,
                                     point: GenericPoint.new(id: 0, state: HeatEquationState.new([0.0, 1.0, 3.0]))
    eq = diff_eq.eqs.first
    eq.expressions.must_equal([
      Expression.new(value_id: 0, constant: 2.0),
      Expression.new(value_id: 1, constant: 3.0)
    ])
  end
end
