class Expression
  getter value_id, constant
  setter constant
  def initialize(@constant = 1.0, @value_id = -1)
  end

  def ==(other)
    value_id == other.value_id && constant == other.constant
  end

  def is_constant?
    value_id == -1
  end

  def /(other : Float64)
    Expression.new value_id: value_id, constant: (constant/other)
  end

  def *(other : Float64)
    Expression.new value_id: value_id, constant: (constant * other)
  end
end
