require "expression"

class EQ
  def initialize(@expressions : Array(Expression) = [] of Expression, @constant : Float64 = 0.0)
  end

  def all_expressions
    @expressions.reduce({} of Int32 => Float64) do |p, c|
      p[c.value_id] ||= 0.0
      p[c.value_id] += c.constant
      p
    end.map { |k, v| Expression.new value_id: k, constant: v }
  end

  def expressions
    all_expressions.reject { |e| e.is_constant? }
  end

  def constant
    all_expressions.select { |e| e.is_constant? }.reduce(@constant) { |p, c| p + c.constant }
  end

  def -(ex : Expression)
    EQ.new expressions: (expressions << (ex * -1.0)), constant: constant
  end

  def -(eq : EQ)
    EQ.new expressions: (eq * -1.0).expressions.concat(expressions), constant: (constant - eq.constant)
  end

  def +(ex : Expression)
    EQ.new expressions: (expressions << ex), constant: constant
  end

  def +(eq : EQ)
    EQ.new expressions: eq.expressions.concat(expressions), constant: (eq.constant + constant)
  end

  def +(c : Float64)
    EQ.new expressions: expressions, constant: (c + constant)
  end

  def -(c : Float64)
    EQ.new expressions: expressions, constant: (constant - c)
  end

  def /(c : Float64)
    EQ.new expressions: expressions.map { |e| e / c }, constant: (constant / c)
  end

  def *(c : Float64)
    EQ.new expressions: expressions.map { |e| e * c }, constant: (constant * c)
  end

  def clone
    EQ.new expressions: expressions, constant: constant
  end
end
