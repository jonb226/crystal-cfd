class HeatEquationState

  @u : Float64
  @x : Float64
  @t : Float64

  getter u, x, t
  def initialize(values)
    @u = values[0]
    @x = values[1]
    @t = values[2]
  end

  def index_for_dimension(field)
    [:u, :x, :t].index {|i| i == field} || -1
  end

  def values
    {@u, @x, @t}
  end

end
