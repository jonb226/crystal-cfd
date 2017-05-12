class Expression
  getter value_id, constant
  def initialize(@constant : Float64, @value_id = -1)
  end

  def ==(other)
    value_id == other.value_id && constant == other.constant
  end

  def is_constant
    value_id == -1
  end
end
