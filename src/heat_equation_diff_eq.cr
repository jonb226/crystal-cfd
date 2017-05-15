require "eq"

class HeatEquationDiffEq(A)
  getter differentiators
  def initialize(@differentiators : A)
  end
  def eqs(point)
    dudt = differentiators.derivative of: :u, with_respect_to: :t, point: point
    d2udx2 = differentiators.derivative of: :u, with_respect_to: :x, point: point, degree: 2
    [(dudt - d2udx2)]
  end
end
