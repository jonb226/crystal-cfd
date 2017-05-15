require "point"

class GenericPoint(A, B)
  include Point
  @id : Int32
  getter id, state, diff_eq
  def initialize(@id, @state : A, @diff_eq : B)
  end

  def eqs
    diff_eq.eqs(self)
  end

  def num_dimensions
    state.values.size
  end

  def index_for_dimension(dimension)
    state.index_for_dimension(dimension)
  end
end
