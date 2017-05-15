require "minitest/autorun"
require "./behaves_like_a"
require "heat_equation_diff_eq"
require "expression"

describe DiffEq do
  class TestPointHEDEQ
  end

  class TestDifferentiator
    def derivative(of, with_respect_to, degree = 1, point = 0)
      if(of == :u && with_respect_to == :t)
        EQ.new + Expression.new(value_id: 0, constant: 2.0)
      else
        EQ.new + Expression.new(value_id: 1, constant: 3.0)
      end
    end
  end

  it "can return the expected diff eq" do
    diff_eq = HeatEquationDiffEq.new differentiators: TestDifferentiator.new
    eq = diff_eq.eqs(TestPointHEDEQ.new).first
    eq.expressions.must_equal([
      Expression.new(value_id: 1, constant: -3.0),
      Expression.new(value_id: 0, constant: 2.0)
    ])
  end
end
