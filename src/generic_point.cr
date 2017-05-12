class GenericPoint(A)
  @id : Int32
  getter id, state
  def initialize(@id, @state : A)
  end
end
