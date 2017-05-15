require "point"
require "generic_point_set"
require "math"

class BasicUniformHeatMesh(A, B, C)
  @last_points : Array(Point)
  @points : Array(Point)
  @last_dt : Float64
  getter length, dx, points, solver
  def initialize(@length : Float64, @num_points : Int32, @point_factory : A, @initial_state : C, @solver : B)
    @points = [] of Point
    @last_points = [] of Point
    @last_dt = 0.0
    num_points.to_i.times do |i|
      x = i.to_f/num_points.to_f
      @points << @point_factory.create id: i, state: [0.1 * Math.sin(Math::PI * x), x, 0.0], mesh: self
    end
  end

  def get_points(dt)
    mv = generate_matrix_and_values(dt)
    new_values = solver.solve(mv[:matrix], mv[:values])
    index = 0
    @points = [] of Point
    @last_points.map do |p|
      index += p.num_dimensions
      @points << @point_factory.create id: p.id, state: new_values[(index - p.num_dimensions)...index], mesh: self
    end
    points
  end

  def generate_matrix_and_values(dt)
    @last_dt = dt
    @last_points = points
    eqs = points[1..-2].flat_map { |p| p.eqs }
    matrix = [] of Array(Float64)
    values = [] of Float64
    eqs.each do |eq|
      row = Array.new(num_value_ids, 0.0)
      eq.expressions.each do |e|
        row[e.value_id] = e.constant
      end
      matrix << row
      values << -1.0 * eq.constant
    end
    points.each do |p|
      row = Array.new(num_value_ids, 0.0)
      row[value_offset(p) + p.index_for_dimension(:x)] = 1.0
      matrix << row
      values << p.state.values[p.index_for_dimension(:x)]
      row2 = Array.new(num_value_ids, 0.0)
      row2[value_offset(p) + p.index_for_dimension(:t)] = 1.0
      matrix << row2
      values << p.state.values[p.index_for_dimension(:t)] + dt
    end

    start = Array.new(num_value_ids, 0.0)
    start[0] = 1.0
    matrix << start
    values << 0.0
    last = Array.new(num_value_ids, 0.0)
    last[points.first.num_dimensions * (points.size - 1)] = 1.0
    matrix << last
    values << 0.0

    {matrix: matrix, values: values}
  end

  def num_value_ids
    points.first.num_dimensions * points.size
  end

  def adjacent_points(point, dimension, along, range = 1)
    to_return = GenericPointSet.new
    if(along == :x)
      add_point_expression(to_return, 0, point, dimension, 0.0)
      range.times do |i|
        [-1, 1].each do |m|
          id = point.id + m * (i + 1)
          add_point_expression(to_return, m * (i + 1), points[id], dimension, get_delta(point, points[id], along))
        end
      end
    else
      state_offset = point.index_for_dimension dimension
      to_return.add location: -1, delta: @last_dt, expression: Expression.new(constant: @last_points[point.id].state.values[point.index_for_dimension(dimension)])
    end
    to_return
  end

  def get_delta(point1, point2, along)
    v1 = point1.state.values[point1.index_for_dimension(along)]
    v2 = point2.state.values[point2.index_for_dimension(along)]
    v2 - v1
  end

  def add_point_expression(point_set, location, point, dimension, delta)
    state_offset = point.index_for_dimension dimension
    point_set.add location: location, delta: delta.abs, expression: Expression.new(value_id: value_offset(point) + state_offset)
  end

  def value_offset(point)
    point.num_dimensions * point.id
  end
end
