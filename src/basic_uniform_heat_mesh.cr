require "point"

class BasicUniformHeatMesh(A, B, C)
  @last_points : Array(Point)
  @points : Array(Point)
  getter length, dx, points, solver, example_state
  def initialize(@length : Float64, @dx : Float64, @point_factory : A, @initial_state : C, @solver : B)
    @points = [] of Point
    (length/dx).to_i.times do |i|
      @points << point_factory.create id: i, state: @initial_state
    end
    @last_points = [] of Point
  end

  def get_points(dt)
    @last_points = points
    eqs = points.flat_map { |p| p.eqs }

    new_values = solver.solve(eqs)
    index = 0
    points = @last_points.map do |p|
      index += p.num_dimensions
      @point_factory.create id: p.id, state: new_values[(index - p.num_dimensions)..(index - 1)]
    end
  end

  def adjacent_point_value_ids(point, dimension, range)
    state_offset = point.index_for_dimension dimension
    if(dimension == :x)
      to_return = [] of Int32
      range.times do |i|
        to_return << value_offset(points[point.id - 1]) + state_offset
        to_return << value_offset(points[point.id + 1]) + state_offset
      end
      return to_return
    else
      return [value_offset(point) + state_offset]
    end
  end

  def value_offset(point)
    point.num_dimensions * point.id
  end
end
