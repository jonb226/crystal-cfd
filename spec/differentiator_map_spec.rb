require "minitest/autorun"
require "point"

class TestDifferentiator
  def derivative(point)
    [Expression.new(value_id: 1, constant: 1)]
  end
end

class TestDifferentiator2
  def derivative(point)
    [Expression.new(value_id: 2, constant: 2)]
  end
end

describe BasicDifferentiatorMap do
  it "can do derivatives" do
    map = BasicDifferentiatorMap.new [
      {of: :a, with_respect_to: :b, "a", differentiator: TestDifferentiator.new},
      {of: :b, with_respect_to: :c, "a", differentiator: TestDifferentiator2.new}
    ]
    map.derivative(of: :a, with_respect_to: :b, point: "a").must_equal(Expression.new(value_id: 1, constant: 1))
    map.derivative(of: :b, with_respect_to: :c, point: "a").must_equal(Expression.new(value_id: 2, constant: 2))
  end
end
