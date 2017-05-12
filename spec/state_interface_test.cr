module StateInterfaceTest
    def test_can_give_an_index_for_a_field
      state.responds_to?(:index_for_field).must_equal(true)
    end
end
