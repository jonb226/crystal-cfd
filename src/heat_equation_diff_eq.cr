require "eq"

class HeatEquationDiffEq(A, B)
  getter differentiators, point
  def initialize(@differentiators : A, @point : B)
  end
  def eqs
    dudt = differentiators.derivative of: :u, with_respect_to: :t, point: point
    d2udx2 = differentiators.derivative of: :u, with_respect_to: :x, point: point, degree: 2
    [EQ.new(expressions: dudt.concat(d2udx2), constant: 0.0)]
  end
end
