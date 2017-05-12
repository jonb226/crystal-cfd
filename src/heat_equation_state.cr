class HeatEquationState

  @u : Float64
  @x : Float64
  @t : Float64

  getter :u, :x, :t
  def initialize(values)
    @u = values[0]
    @x = values[1]
    @t = values[2]
  end

  def index_for_field(field)
    {:u, :x, :t}.find_index(field)
  end

  def values
    {@u, @x, @t}
  end

end
