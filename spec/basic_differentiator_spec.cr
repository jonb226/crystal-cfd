require "minitest/autorun"
require "basic_differentiator"

struct DifferTestRelativePoint
  getter expression, delta
  def initialize(@expression : Expression, @delta : Float64)
  end
end

class DifferTestPointSet
  def point(location)
    case location
    when -1
      DifferTestRelativePoint.new expression: Expression.new(constant: 3.0), delta: 2.0
    when 1
      DifferTestRelativePoint.new expression: Expression.new(constant: 12.0), delta: 8.0
    else
      DifferTestRelativePoint.new expression: Expression.new(constant: 4.0), delta: 0.0
    end
  end
  def point_exists?(location)
    true
  end
end

class DifferTestPointSetNoBefore
  def point(location)
    case location
    when 1
      DifferTestRelativePoint.new expression: Expression.new(constant: 3.0), delta: 4.0
    when 2
      DifferTestRelativePoint.new expression: Expression.new(constant: 5.0), delta: 8.0
    else
      DifferTestRelativePoint.new expression: Expression.new(constant: 4.0), delta: 0.0
    end
  end
  def point_exists?(location)
    false
  end
end

class DifferTestPointSetNoAfter
  def point(location)
    case location
    when -1
      DifferTestRelativePoint.new expression: Expression.new(constant: 3.0), delta: 4.0
    when -2
      DifferTestRelativePoint.new expression: Expression.new(constant: 7.0), delta: 8.0
    else
      DifferTestRelativePoint.new expression: Expression.new(constant: 3.0), delta: 0.0
    end
  end
  def point_exists?(location)
    (location == -1) ? true : false
  end
end

class DifferTestMesh
  def adjacent_points(point, dimension, along, range)
    DifferTestPointSet.new
  end
end

class DifferTestMeshNoBefore
  def adjacent_points(point, dimension, along, range)
    DifferTestPointSetNoBefore.new
  end
end

class DifferTestMeshNoAfter
  def adjacent_points(point, dimension, along, range)
    DifferTestPointSetNoAfter.new
  end
end

class DifferTestPoint
  def point_id
    1
  end
end

describe BasicDifferentiator do
  def differentiator
    BasicDifferentiator.new mesh: DifferTestMesh.new
  end

  it "can do a first derivative" do
    differentiator.derivative(point: DifferTestPoint.new, of: :x, with_respect_to: :x).constant.must_equal(0.5)
  end

  it "can do a first derivative with no before" do
    differentiator = BasicDifferentiator.new mesh: DifferTestMeshNoBefore.new
    differentiator.derivative(point: DifferTestPoint.new, of: :x, with_respect_to: :x).constant.must_equal(-0.25)
  end

  it "can do a second derivative" do
    differentiator.derivative(point: DifferTestPoint.new, of: :x, with_respect_to: :x, degree: 2).constant.must_equal(0.1)
  end

  it "can do a second derivative with no before" do
    differentiator = BasicDifferentiator.new mesh: DifferTestMeshNoBefore.new
    differentiator.derivative(point: DifferTestPoint.new, of: :x, with_respect_to: :x, degree: 2).constant.must_equal(0.1875)
  end

  it "can do a second derivative with no after" do
    differentiator = BasicDifferentiator.new mesh: DifferTestMeshNoAfter.new
    differentiator.derivative(point: DifferTestPoint.new, of: :x, with_respect_to: :x, degree: 2).constant.must_equal(0.25)
  end

end
