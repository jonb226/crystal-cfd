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

  it "can add/subtract an expression" do
    eq = EQ.new expressions: [
      Expression.new(value_id: 0, constant: 1.0),
      Expression.new(value_id: 1, constant: 2.0)
    ], constant: 10.0
    new_eq = (eq +
      Expression.new(value_id: 0, constant: 3.0) -
      Expression.new(value_id: 1, constant: 12.0) -
      Expression.new(constant: 20.0) +
      Expression.new(constant: 100.0)
    )
    new_eq.expressions.must_equal([
      Expression.new(value_id: 0, constant: 4.0),
      Expression.new(value_id: 1, constant: -10.0)
    ])
    new_eq.constant.must_equal(90.0)
  end

  it "can add/subtract eqs" do
    eq1 = EQ.new expressions: [
      Expression.new(value_id: 0, constant: 1.0),
      Expression.new(value_id: 1, constant: 2.0)
    ], constant: 10.0

    eq2 = EQ.new expressions: [
      Expression.new(value_id: 0, constant: 4.0),
      Expression.new(value_id: 1, constant: 7.0)
    ], constant: 20.0

    (eq1 + eq2).constant.must_equal(30)
    (eq1 + eq2).expressions.must_equal([
      Expression.new(value_id: 0, constant: 5.0),
      Expression.new(value_id: 1, constant: 9.0)
    ])

    (eq1 - eq2).constant.must_equal(-10.0)
    (eq1 - eq2).expressions.must_equal([
      Expression.new(value_id: 0, constant: -3.0),
      Expression.new(value_id: 1, constant: -5.0)
    ])
  end

  it "can be multiplied" do
    eq = EQ.new expressions: [
      Expression.new(value_id: 0, constant: 1.0),
      Expression.new(value_id: 1, constant: 2.0)
    ], constant: 10.0

    (eq * 3.0).constant.must_equal(30.0)
    (eq * 3.0).expressions.must_equal([
      Expression.new(value_id: 0, constant: 3.0),
      Expression.new(value_id: 1, constant: 6.0)
    ])
  end

  it "can be divided" do
    eq = EQ.new expressions: [
      Expression.new(value_id: 0, constant: 3.0),
      Expression.new(value_id: 1, constant: 6.0)
    ], constant: 30.0

    (eq / 3.0).constant.must_equal(10.0)
    (eq / 3.0).expressions.must_equal([
      Expression.new(value_id: 0, constant: 1.0),
      Expression.new(value_id: 1, constant: 2.0)
    ])
  end

  it "can have a negative constant divided" do
    eq = EQ.new expressions: [
      Expression.new(value_id: -1, constant: 3.0)
    ], constant: -12.0

    (eq / 3.0).constant.must_equal(-3.0)
  end
end
