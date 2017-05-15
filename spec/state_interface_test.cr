module StateInterfaceTest
    def test_can_give_an_index_for_a_dimension
      state.responds_to?(:index_for_dimension).must_equal(true)
    end
end
