class EQ(A)
  getter constant
  def initialize(@expressions : A, @constant : Float64)
  end

  def expressions
    @expressions.reduce({} of Int32 => Float64) do |p, c|
      p[c.value_id] ||= 0.0
      p[c.value_id] += c.constant
      p
    end.map { |k, v| Expression.new value_id: k, constant: v }
  end
end
