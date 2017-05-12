require "minitest/autorun"

describe EQ do
  it "combines expressions for the same value" do
    eq = EQ.new expressions: [
      Expression.new(value_id: 0, constant: 1.0),
      Expression.new(value_id: 0, constant: 1.0),
      Expression.new(value_id: 1, constant: 1.0),
      Expression.new(value_id: 2, constant: 5.0),
      Expression.new(value_id: 2, constant: 3.0)
    ], constant: 0.0
    eq.expressions.must_equal([
      Expression.new(value_id: 0, constant: 2.0),
      Expression.new(value_id: 1, constant: 1.0),
      Expression.new(value_id: 2, constant: 8.0)
    ])
  end
end
