require "minitest/autorun"
require "basic_uniform_heat_mesh"
require "point"
require "expression"

describe BasicUniformHeatMesh do
  class TestPointFactory
    def create(id, state, mesh)
      TestPoint.new id: id, state: TestState.new(state)
    end
  end

  class TestPoint
    include Point
    getter id, state
    def initialize(@id : Int32, @state : TestState)
    end
    def ==(other)
      id == other.id && state == other.state
    end
    def eqs
      [] of EQ
    end
    def num_dimensions
      2
    end
    def index_for_dimension(dimension)
      1
    end
  end

  class TestSolver
    def solve(matrix, values)
      to_return = [] of Float64
      22.times { |i| to_return << i.to_f }
      return to_return
    end
  end

  class TestState
    def initialize(@state : Array(Float64))
    end
    def values
      @state
    end
    def index_for_field(field)
      1
    end
    def ==(other)
      values.map_with_index { |e, i|  other.values[i] - e < 0.01 || other.values[i] - e > -0.01}.all?
    end
  end

  it "can get new points" do
    points = [] of TestPoint
    10.times { |i| points << TestPoint.new id: i, state: TestState.new([2.0*i, 2.0*i + 1]) }
    mesh.get_points(0.1).must_equal(points)
  end

  def mesh
     BasicUniformHeatMesh.new length: 1.0,
                              num_points: 10,
                              point_factory: TestPointFactory.new,
                              initial_state: [2.0, 2.0],
                              solver: TestSolver.new
  end

  let(:point) { TestPoint.new id: 3, state: TestState.new([0.0, 0.0]) }

  it "can get adjacent spatial points" do
    adjacent_points = mesh.adjacent_points point: point, dimension: :x, along: :x
    adjacent_points.point(location: 1).expression.value_id.must_equal(9)
  end

  it "can get adjacent temporal points" do
    test_mesh = mesh
    new_points = test_mesh.get_points(0.1)
    adjacent_points = test_mesh.adjacent_points point: point, dimension: :t, range: 1, along: :t
    adjacent_points.point(location: -1).expression.constant.must_be_close_to(0.3)
  end
end
